$PBExportHeader$w_imt_05060.srw
$PBExportComments$년간 구매계획 대 실적[거래처별 품목별]
forward
global type w_imt_05060 from w_standard_print
end type
type shl_1 from statichyperlink within w_imt_05060
end type
type st_1 from statictext within w_imt_05060
end type
type st_2 from statictext within w_imt_05060
end type
type shl_4 from statichyperlink within w_imt_05060
end type
type st_3 from statictext within w_imt_05060
end type
type shl_5 from statichyperlink within w_imt_05060
end type
type shl_6 from statichyperlink within w_imt_05060
end type
type st_21 from statictext within w_imt_05060
end type
type rr_1 from roundrectangle within w_imt_05060
end type
end forward

global type w_imt_05060 from w_standard_print
string title = "년간 구매계획 대 실적[거래처별 품목별]"
string menuname = ""
shl_1 shl_1
st_1 st_1
st_2 st_2
shl_4 shl_4
st_3 st_3
shl_5 shl_5
shl_6 shl_6
st_21 st_21
rr_1 rr_1
end type
global w_imt_05060 w_imt_05060

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();IF dw_ip.AcceptText() = -1 THEN Return -1

String	ls_yymm, ls_cvcod, ls_mitcls, ls_saupj, ls_iogbn

ls_yymm  = dw_ip.GetItemString(1, 'yymm')
ls_cvcod = dw_ip.GetItemString(1, 'cvcod')
ls_mitcls = dw_ip.GetItemString(1, 'mitcls')
ls_saupj = dw_ip.GetItemString(1, 'saupj')

IF ls_yymm = '' OR IsNull(ls_yymm) THEN
	f_message_chk(30, '[기준년월]')
	dw_ip.SetFocus()
	Return -1
END IF

IF ls_cvcod = '' OR IsNull(ls_cvcod) THEN
	f_message_chk(30, '[거래처]')
	dw_ip.SetFocus()
	Return -1
END IF

// head 처리
dw_list.object.m_11.text = RIGHT(f_aftermonth(ls_yymm, -11),2) +'월'
dw_list.object.m_10.text = RIGHT(f_aftermonth(ls_yymm, -10),2) +'월'
dw_list.object.m_9.text  = RIGHT(f_aftermonth(ls_yymm, -9),2)  +'월' 
dw_list.object.m_8.text  = RIGHT(f_aftermonth(ls_yymm, -8),2) +'월' 
dw_list.object.m_7.text  = RIGHT(f_aftermonth(ls_yymm, -7),2) +'월' 
dw_list.object.m_6.text  = RIGHT(f_aftermonth(ls_yymm, -6),2) +'월'  
dw_list.object.m_5.text  = RIGHT(f_aftermonth(ls_yymm, -5),2) +'월' 
dw_list.object.m_4.text  = RIGHT(f_aftermonth(ls_yymm, -4),2) +'월' 
dw_list.object.m_3.text  = RIGHT(f_aftermonth(ls_yymm, -3),2) +'월' 
dw_list.object.m_2.text  = RIGHT(f_aftermonth(ls_yymm, -2),2) +'월' 
dw_list.object.m_1.text  = RIGHT(f_aftermonth(ls_yymm, -1),2) +'월' 
dw_list.object.m.text    = RIGHT(ls_yymm,2) +'월' 

ls_iogbn = dw_ip.GetItemString(1, 'iogbn')
IF ls_iogbn = '' OR IsNull(ls_iogbn) THEN ls_iogbn = '%'

IF dw_list.Retrieve(ls_yymm, ls_cvcod, gs_codename2, ls_mitcls, ls_saupj, ls_iogbn) <= 0 THEN
	f_message_chk(50, '[]')
	Return -1
END IF

Return 1
end function

on w_imt_05060.create
int iCurrent
call super::create
this.shl_1=create shl_1
this.st_1=create st_1
this.st_2=create st_2
this.shl_4=create shl_4
this.st_3=create st_3
this.shl_5=create shl_5
this.shl_6=create shl_6
this.st_21=create st_21
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.shl_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.shl_4
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.shl_5
this.Control[iCurrent+7]=this.shl_6
this.Control[iCurrent+8]=this.st_21
this.Control[iCurrent+9]=this.rr_1
end on

on w_imt_05060.destroy
call super::destroy
destroy(this.shl_1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.shl_4)
destroy(this.st_3)
destroy(this.shl_5)
destroy(this.shl_6)
destroy(this.st_21)
destroy(this.rr_1)
end on

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

//대분류/중분류
DataWindowChild big_child, state_child
integer rtncode
String  ls_cvnas, ls_parm

rtncode = dw_ip.GetChild('itcls',  big_child)
rtncode = dw_ip.GetChild('mitcls', state_child)

IF rtncode = -1 THEN MessageBox( &
		"Error", "Not a DataWindowChild")
CONNECT USING SQLCA;

state_child.SetTransObject(SQLCA)
big_child.SetTransObject(SQLCA)
state_child.Retrieve(gs_codename2)
big_child.SetTransObject(SQLCA)
big_child.Retrieve()

dw_ip.settransobject(sqlca)
dw_ip.InsertRow(0)

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

dw_ip.SetItem(1, 'saupj', gs_saupj)

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
//sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"
//--------------------------------------------------------------------
dw_ip.SetItem(1, 'yymm',  gs_gubun)
dw_ip.SetItem(1,'cvcod',  gs_code)
dw_ip.SetItem(1,'mitcls', gs_codename)

f_mod_saupj(dw_ip, 'saupj')

ls_parm  =  left(gs_codename,2)
dw_ip.SetItem(1,'itcls',  ls_parm)

String ls_iogbn
ls_iogbn = Message.StringParm	
If ls_iogbn <> '%' and Not(IsNull(ls_iogbn)) Then
	dw_ip.SetItem(1,'iogbn', ls_iogbn)
End If

select cvnas2
into  :ls_cvnas
from   vndmst
where  cvcod = :gs_code;
dw_ip.SetItem(1,'cvnas',  ls_cvnas)
//state_child.setItem(1,'itcls',gs_code)

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

wf_retrieve()
end event

type p_preview from w_standard_print`p_preview within w_imt_05060
boolean visible = false
integer x = 3680
integer y = 16
end type

type p_exit from w_standard_print`p_exit within w_imt_05060
end type

type p_print from w_standard_print`p_print within w_imt_05060
boolean visible = false
integer x = 3854
integer y = 16
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_05060
integer x = 4265
end type







type st_10 from w_standard_print`st_10 within w_imt_05060
end type



type dw_print from w_standard_print`dw_print within w_imt_05060
integer x = 4091
integer y = 40
string dataobject = "d_imt_05060_1"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_05060
integer y = 96
integer width = 3653
integer height = 220
string dataobject = "d_imt_05060"
end type

event dw_ip::itemchanged;call super::itemchanged;String sCvcod, sNull, sCvnas, sArea, sTeam, sSaupj, sName1

Choose Case getColumnName()
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvcod",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvnas', snull)
			Return 1
		ELSE		
			SetItem(1,"cvnas", scvnas)
		END IF
	/* 거래처명 */
	Case "cvnas"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"cvcod",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvnas', snull)
			Return 1
		ELSE		
			SetItem(1,'cvcod', sCvcod)
			SetItem(1,"cvnas", scvnas)

			Return 1
		END IF
END CHOOSE
end event

event dw_ip::rbuttondown;call super::rbuttondown;string sIocvnas, sIoCustArea,	sDept,sIoGbn,sNull

SetNull(sNull)
SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	Case "cvcod", "cvnas"
		gs_gubun = '1'
		If GetColumnName() = "cvnas" then
			gs_codename = Trim(GetText())
		End If
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)

// Case "cvcod","cvnas"
//	sIoGbn = Trim(this.GetItemString(1,'iogbn'))
//
//	If sIogbn = 'Y' Then
//	  gs_gubun = '1'
//		If GetColumnName() = "cvnas" then
//			gs_codename = Trim(GetText())
//		End If
//	  Open(w_agent_popup)
//	
//	  IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//	
//	  this.SetItem(1,"cvcod",gs_code)
//	
//	  SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//	    INTO :sIocvnas,		:sIoCustArea,			:sDept
//	    FROM "VNDMST","SAREA" 
//     WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//		
//	  IF SQLCA.SQLCODE = 0 THEN
//	    this.SetItem(1,"deptcode",  sDept)
//	    this.SetItem(1,"cvnas",  sIocvnas)
//	    this.SetItem(1,"areacode",  sIoCustArea)
//	  END IF
//	Else
//	  Open(w_dept_popup)
//	  IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//	
//  	  this.SetItem(1,"cvcod",  gs_code)
//	  this.SetItem(1,"cvnas",  gs_codeName)
//	  this.SetItem(1,"deptcode",  sNull)
//	  this.SetItem(1,"areacode",  sNull)
//	End If
END Choose

end event

type dw_list from w_standard_print`dw_list within w_imt_05060
event ue_mousemove pbm_mousemove
integer x = 46
integer y = 364
integer width = 4549
integer height = 1944
string dataobject = "d_imt_05060_1"
boolean border = false
end type

event dw_list::ue_mousemove;String ls_Object
Long	 ll_Row

IF this.Rowcount() < 1 then return 

ls_Object = Lower(This.GetObjectAtPointer())

IF mid(ls_Object, 1, 11)  = 'itnct_titnm' THEN 
   ll_Row = long(mid(ls_Object, 12, 5))
	this.setrow(ll_row)
	this.setitem(ll_row, 'opt', '1')
ELSE
	this.setitem(this.getrow(), 'opt', '0')
END IF


end event

type shl_1 from statichyperlink within w_imt_05060
integer x = 69
integer y = 36
integer width = 192
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
string text = "년월별"
alignment alignment = center!
end type

event clicked;Boolean				lb_isopen
Window				lw_window

lb_isopen = FALSE
lw_window = parent.GetFirstSheet()
DO WHILE IsValid(lw_window)
	if ClassName(lw_window) = 'w_imt_05010' then
		lb_isopen = TRUE
		Exit
	else		
		lw_window = parent.GetNextSheet(lw_window)
	end if
LOOP
if lb_isopen then
	lw_window.windowstate = Normal!
	lw_window.SetFocus()
else	
	OpenSheet(w_imt_05010, w_mdi_frame, 0, Layered!)	
end if

close(Parent)
close(w_imt_05040)
end event

type st_1 from statictext within w_imt_05060
integer x = 283
integer y = 36
integer width = 114
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = ">>"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_imt_05060
integer x = 1083
integer y = 36
integer width = 114
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = ">>"
alignment alignment = center!
boolean focusrectangle = false
end type

type shl_4 from statichyperlink within w_imt_05060
integer x = 2021
integer y = 36
integer width = 640
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
boolean enabled = false
string text = "거래처별 품목별"
boolean focusrectangle = false
end type

type st_3 from statictext within w_imt_05060
integer x = 1883
integer y = 36
integer width = 114
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = ">>"
alignment alignment = center!
boolean focusrectangle = false
end type

type shl_5 from statichyperlink within w_imt_05060
integer x = 421
integer y = 36
integer width = 640
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
string text = "거래처별 품목대분류별"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;Boolean				lb_isopen
Window				lw_window

lb_isopen = FALSE
lw_window = parent.GetFirstSheet()
DO WHILE IsValid(lw_window)
	if ClassName(lw_window) = 'w_imt_05040' then
		lb_isopen = TRUE
		Exit
	else		
		lw_window = parent.GetNextSheet(lw_window)
	end if
LOOP
if lb_isopen then
	lw_window.windowstate = Normal!
	lw_window.SetFocus()
else	
	OpenSheet(w_imt_05040, w_mdi_frame, 0, Layered!)	
end if

close(Parent)
close(w_imt_05050)
end event

type shl_6 from statichyperlink within w_imt_05060
integer x = 1225
integer y = 36
integer width = 640
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
string text = "거래처별 품목중분류별"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;Boolean				lb_isopen
Window				lw_window

lb_isopen = FALSE
lw_window = parent.GetFirstSheet()
DO WHILE IsValid(lw_window)
	if ClassName(lw_window) = 'w_imt_05050' then
		lb_isopen = TRUE
		Exit
	else		
		lw_window = parent.GetNextSheet(lw_window)
	end if
LOOP
if lb_isopen then
	lw_window.windowstate = Normal!
	lw_window.SetFocus()
else	
	OpenSheet(w_imt_05050, w_mdi_frame, 0, Layered!)	
end if

close(Parent)

end event

type st_21 from statictext within w_imt_05060
integer x = 4251
integer y = 288
integer width = 334
integer height = 44
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 31778020
string text = "(단위:천원)"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_imt_05060
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 356
integer width = 4576
integer height = 1960
integer cornerheight = 40
integer cornerwidth = 55
end type

