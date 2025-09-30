$PBExportHeader$w_sal_02591.srw
$PBExportComments$수주 취소현황 - 제품별
forward
global type w_sal_02591 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_02591
end type
type pb_2 from u_pb_cal within w_sal_02591
end type
type rr_1 from roundrectangle within w_sal_02591
end type
end forward

global type w_sal_02591 from w_standard_print
string title = "수주 취소현황 - 제품별"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_sal_02591 w_sal_02591

type variables
str_itnct str_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sIttyp, sItcls, sItnbr, tx_name, sOrdCancelCause,ssaupj
String sFRom, sTo ,ls_emp_id

If dw_ip.AcceptText() <> 1 Then Return -1

sFrom       = Trim(dw_ip.GetItemString(1,"sdatef"))
sTo         = Trim(dw_ip.GetItemString(1,"sdatet"))
sIttyp      = Trim(dw_ip.GetItemString(1,"ittyp"))
ssaupj      = dw_ip.getitemstring(1,"saupj")
ls_emp_id   = dw_ip.getitemstring(1,'emp_id')

if sittyp="" or isnull(sittyp) then 
	f_message_chk(30,'[품목구분]')
	return -1
end if

If IsNull(sSaupj) Or sSaupj = '' Then sSaupj = '%'
//	f_message_chk(1400,'[부가사업장]')
//	dw_ip.SetFocus()
//	Return -1
//End If

sItcls      = Trim(dw_ip.GetItemString(1,"itcls"))
sItnbr      = Trim(dw_ip.GetItemString(1,"itnbr"))
sOrdCancelCause = Trim(dw_ip.GetItemString(1,"ord_cancel_cause"))

IF sFrom = "" OR IsNull(sFrom) THEN
	f_message_chk(30,'[수주기간]')
	dw_ip.SetColumn("sdatef")
	dw_ip.SetFocus()
	Return -1
END IF

IF sTo = "" OR IsNull(sTo) THEN
	f_message_chk(30,'[수주기간]')
	dw_ip.SetColumn("sdatet")
	dw_ip.SetFocus()
	Return -1
END IF

If Isnull(sIttyp) Then sIttyp = ''
If Isnull(sItcls) Then sItcls = ''
If Isnull(sItnbr) Then sItnbr = ''
If Isnull(sOrdCancelCause) Then sOrdCancelCause = ''
if ls_emp_id = "" or isnull(ls_emp_id) then ls_emp_id = '%'

//IF dw_list.Retrieve(gs_sabu, sFrom, sTo, sIttyp+'%',sItcls+'%',sItnbr+'%', sOrdCancelCause+'%',ssaupj,ls_emp_id) <=0 THEN
//	f_message_chk(50,'')
//   dw_ip.setcolumn('sdatef')
//	dw_ip.SetFocus()
//	Return -1
//END IF

IF dw_print.Retrieve(gs_sabu, sFrom, sTo, sIttyp+'%',sItcls+'%',sItnbr+'%', sOrdCancelCause+'%',ssaupj,ls_emp_id) <=0 THEN
	f_message_chk(50,'')
   dw_ip.setcolumn('sdatef')
	dw_ip.SetFocus()
	Return -1
END IF

dw_print.ShareData(dw_list)

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ittyp) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("txt_ittyp.text = '"+tx_name+"'")
dw_print.Modify("txt_ittyp.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.GetitemString(1,'itclsnm'))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("txt_itcls.text = '"+tx_name+"'")
dw_print.Modify("txt_itcls.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.GetitemString(1,'itdsc'))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("txt_itdsc.text = '"+tx_name+"'")
dw_print.Modify("txt_itdsc.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ord_cancel_cause) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("txt_cause.text = '"+tx_name+"'")
dw_print.Modify("txt_cause.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_saupj.text = '"+tx_name+"'")
dw_print.Modify("tx_saupj.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(emp_id) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_emp_id.text = '"+tx_name+"'")
dw_print.Modify("tx_emp_id.text = '"+tx_name+"'")

Return 1
end function

on w_sal_02591.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_sal_02591.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;Long rtncode 
datawindowchild state_child

dw_ip.SetItem(1,"sdatef", Left(is_today,6)+'01')
dw_ip.SetItem(1,"sdatet", is_today)

dw_ip.Setfocus()

/* User별 관할구역 Setting */
String sarea, steam , saupj

//If f_check_sarea(sarea, steam, saupj) = 1 Then
//	dw_ip.SetItem(1, 'saupj', saupj)
//End If
f_mod_saupj(dw_ip, 'saupj')

//영업담당자
rtncode 	= dw_ip.GetChild('emp_id', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업담당자")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('47',gs_saupj)


dw_ip.reset() 
dw_ip.insertrow(0) 
dw_ip.setitem(1, 'saupj', gs_saupj ) 



sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"

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

type p_preview from w_standard_print`p_preview within w_sal_02591
string picturename = "C:\ERPMAN\image\미리보기_up.gif"
end type

type p_exit from w_standard_print`p_exit within w_sal_02591
string picturename = "C:\ERPMAN\image\닫기_up.gif"
end type

type p_print from w_standard_print`p_print within w_sal_02591
string picturename = "C:\ERPMAN\image\인쇄_up.gif"
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_02591
string picturename = "C:\ERPMAN\image\조회_up.gif"
end type











type dw_print from w_standard_print`dw_print within w_sal_02591
string dataobject = "d_sal_02590_01_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_02591
integer x = 46
integer y = 24
integer width = 3419
integer height = 432
string dataobject = "d_sal_025902"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemfocuschanged;
IF this.GetColumnName() = "custname" OR this.GetColumnName() ='deptname'THEN
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))
END IF
end event

event dw_ip::itemchanged;String  sNull, sIttyp, sItcls, sItnbr, sItdsc, sIspec, sDateFrom
String  sItemCls, sItemGbn, sItemClsName, sjijil, sispeccode, ls_saupj, ls_emp_id
Long    nRow, ireturn, rtncode 
datawindowchild state_child

SetNull(snull)

nRow = GetRow()
If nRow <= 0 Then Return

SetPointer(HourGlass!)

Choose Case GetColumnName() 
	Case "sdatef","sdatet"
		sDateFrom = Trim(this.GetText())
		IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
		
		IF f_datechk(sDateFrom) = -1 THEN
			f_message_chk(35,'[수주기간]')
			this.SetItem(1,GetColumnName(),snull)
			Return 1
		END IF
	/* 품목구분 */
	Case "ittyp"
		SetItem(nRow,'itcls',sNull)
		SetItem(nRow,'itclsnm',sNull)
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
		SetItem(nRow,'ispec',sNull)
	/* 품목분류 */
	Case "itcls"
		SetItem(nRow,'itclsnm',sNull)
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
		SetItem(nRow,'ispec',sNull)
		
		sItemCls = Trim(GetText())
		IF sItemCls = "" OR IsNull(sItemCls) THEN 		RETURN
		
		sItemGbn = this.GetItemString(1,"ittyp")
		IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
			
			SELECT "ITNCT"."TITNM"  	INTO :sItemClsName  
			  FROM "ITNCT"  
			 WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."ITCLS" = :sItemCls )   ;
				
			IF SQLCA.SQLCODE <> 0 THEN
				this.TriggerEvent(RButtonDown!)
				Return 2
			ELSE
				this.SetItem(1,"itclsnm",sItemClsName)
			END IF
		END IF
	/* 품목명 */
	Case "itclsnm"
		SetItem(1,"itcls",snull)
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
		SetItem(nRow,'ispec',sNull)
		
		sItemClsName = this.GetText()
		IF sItemClsName = "" OR IsNull(sItemClsName) THEN return
		
		sItemGbn = this.GetItemString(1,"ittyp")
		IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
		  SELECT "ITNCT"."ITCLS"	INTO :sItemCls
			 FROM "ITNCT"  
			WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."TITNM" = :sItemClsName )   ;
				
		  IF SQLCA.SQLCODE <> 0 THEN
			 this.TriggerEvent(RButtonDown!)
			 Return 2
		  ELSE
			 this.SetItem(1,"itcls",sItemCls)
		  END IF
		END IF
	/* 품번 */
	Case "itnbr"
		sItnbr = trim(GetText())
	
		ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(nRow, "itnbr", sitnbr)	
		setitem(nRow, "itdsc", sitdsc)	
		setitem(nRow, "ispec", sispec)
//		setitem(nRow, "ispec_code", sispeccode)
//		setitem(nRow, "jijil", sjijil)
		RETURN ireturn
	/* 품명 */
	Case "itdsc"
		sItdsc = trim(GetText())
	
		ireturn = f_get_name4('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(nRow, "itnbr", sitnbr)	
		setitem(nRow, "itdsc", sitdsc)	
		setitem(nRow, "ispec", sispec)
//		setitem(nRow, "ispec_code", sispeccode)
//		setitem(nRow, "jijil", sjijil)
		RETURN ireturn
	/* 규격 */
	Case "ispec"
		sIspec = trim(GetText())
	
		ireturn = f_get_name4('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(nRow, "itnbr", sitnbr)	
		setitem(nRow, "itdsc", sitdsc)	
		setitem(nRow, "ispec", sispec)
//		setitem(nRow, "ispec_code", sispeccode)
//		setitem(nRow, "jijil", sjijil)
		RETURN ireturn
		
	case 'saupj' 
		STRING ls_return, ls_sarea , ls_steam  
		ls_saupj = gettext() 

		//영업담당자
		rtncode 	= dw_ip.GetChild('emp_id', state_child)
		IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업담당자")
		state_child.SetTransObject(SQLCA)
		state_child.Retrieve('47',ls_saupj)
		ls_emp_id = dw_ip.object.emp_id[1] 
//		ls_return = f_saupj_chk_t('3' , ls_emp_id ) 
//		if ls_return <> ls_saupj and ls_saupj <> '%' then 
//				dw_ip.setitem(1, 'emp_id', '')
//		End if 
		
END Choose

end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetcolumnName() 
  Case "itcls"
	 OpenWithParm(w_ittyp_popup, this.GetItemString(this.GetRow(),"ittyp"))
	
    str_sitnct = Message.PowerObjectParm	
	
	 IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
	
	 this.SetItem(1,"itcls",str_sitnct.s_sumgub)
	 this.SetItem(1,"itclsnm", str_sitnct.s_titnm)
	 this.SetItem(1,"ittyp",  str_sitnct.s_ittyp)
	 
	 SetColumn('itnbr')
  Case "itclsnm"
	 OpenWithParm(w_ittyp_popup, this.GetItemString(this.GetRow(),"ittyp"))
    str_sitnct = Message.PowerObjectParm
	
	 IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
	
	 this.SetItem(1,"itcls",   str_sitnct.s_sumgub)
	 this.SetItem(1,"itclsnm", str_sitnct.s_titnm)
	 this.SetItem(1,"ittyp",   str_sitnct.s_ittyp)
	 
	 SetColumn('itnbr')
/* ---------------------------------------- */
  Case "itnbr" ,"itdsc", "ispec"
		gs_gubun = Trim(GetItemString(1,'ittyp'))
	  Open(w_itemas_popup)
	  IF gs_code = "" OR IsNull(gs_code) THEN RETURN

	  this.SetItem(1,"itnbr",gs_code)
	  this.SetFocus()
	  this.SetColumn('itnbr')
	  this.PostEvent(ItemChanged!)
END Choose
end event

event dw_ip::ue_key;call super::ue_key;string sCol

SetNull(gs_code)
SetNull(gs_codename)

IF KeyDown(KeyF2!) THEN
	Choose Case GetColumnName()
	   Case  'itcls'
		    open(w_ittyp_popup3) 
			 str_sitnct = Message.PowerObjectParm
			 if IsNull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then return
		    this.SetItem(1, "ittyp", str_sitnct.s_ittyp)
		    this.SetItem(1, "itcls", str_sitnct.s_sumgub)
		    this.SetItem(1, "itclsnm", str_sitnct.s_titnm)
	END Choose
End if	
end event

type dw_list from w_standard_print`dw_list within w_sal_02591
integer x = 59
integer y = 480
integer width = 4526
integer height = 1832
string dataobject = "d_sal_02590_01"
boolean border = false
end type

type pb_1 from u_pb_cal within w_sal_02591
integer x = 837
integer y = 64
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatef')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatef', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_02591
integer x = 1289
integer y = 60
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatet')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatet', gs_code)
end event

type rr_1 from roundrectangle within w_sal_02591
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 476
integer width = 4558
integer height = 1844
integer cornerheight = 40
integer cornerwidth = 55
end type

