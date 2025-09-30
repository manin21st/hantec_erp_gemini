$PBExportHeader$w_sal_02580.srw
$PBExportComments$납기준수 현황
forward
global type w_sal_02580 from w_standard_print
end type
type rb_1 from radiobutton within w_sal_02580
end type
type rb_2 from radiobutton within w_sal_02580
end type
type pb_1 from u_pb_cal within w_sal_02580
end type
type pb_2 from u_pb_cal within w_sal_02580
end type
type rr_1 from roundrectangle within w_sal_02580
end type
type rr_2 from roundrectangle within w_sal_02580
end type
end forward

global type w_sal_02580 from w_standard_print
integer height = 2440
string title = "납기준수 현황"
rb_1 rb_1
rb_2 rb_2
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
rr_2 rr_2
end type
global w_sal_02580 w_sal_02580

type variables
str_itnct str_sitnct
String sSqlsyntax
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFrom,sTo,sArea,sAreaName,sord_datef,sord_datet,spdtgu,sittyp,sitcls,tx_name
String sMaxDate,sMinDate, sCvcod, sItnbr,ls_sugugb,ls_pangb,ssaupj,ls_emp_id
String sNewSyntax
Long   nRtn

If dw_ip.AcceptText() <> 1 then Return -1

sFrom       = Trim(dw_ip.GetItemString(1,"sdatef"))
sTo         = Trim(dw_ip.GetItemString(1,"sdatet"))
sOrd_datef  = Trim(dw_ip.GetItemString(1,"sord_datef"))
sOrd_datet  = Trim(dw_ip.GetItemString(1,"sord_datet"))
sArea       = Trim(dw_ip.GetItemString(1,"areacode"))
sCvcod      = Trim(dw_ip.GetItemString(1,"custcode"))
spdtgu      = Trim(dw_ip.GetItemString(1,"pdtgu"))
sittyp      = Trim(dw_ip.GetItemString(1,"ittyp"))
sitcls      = Trim(dw_ip.GetItemString(1,"itcls"))
sitnbr      = Trim(dw_ip.GetItemString(1,"itnbr"))
ls_sugugb   = Trim(dw_ip.Getitemstring(1,"sugugb"))
ls_pangb    = trim(dw_ip.getitemstring(1,"pangb"))
ssaupj = dw_ip.getitemstring(1,"saupj")
ls_emp_id   = dw_ip.getitemstring(1,'emp_id')

IF sOrd_datef = "" OR IsNull(sOrd_datef) THEN
	f_message_chk(30,'[수주기간]')
	dw_ip.SetColumn("sord_datef")
	dw_ip.SetFocus()
	Return -1
END IF

IF sOrd_datet = "" OR IsNull(sOrd_datet) THEN
	f_message_chk(30,'[수주기간]')
	dw_ip.SetColumn("sord_datet")
	dw_ip.SetFocus()
	Return -1
END IF

If IsNull(sSaupj) Or sSaupj = '' Then sSaupj = ''
//	f_message_chk(1400,'[부가사업장]')
//	dw_ip.SetFocus()
//	Return -1
//End If

/* 수주기간 from ~ to */
Select min(order_date),max(order_date) 
  into :sMinDate, :sMaxDate
  from sorder;
  
IF sOrd_datef  = "" OR IsNull(sOrd_datef) THEN 
	sOrd_datef = sMinDate
End If
IF sOrd_datet  = "" OR IsNull(sOrd_datet) THEN 
	sOrd_datet = sMaxDate
End If

IF sArea  = "" OR IsNull(sArea) THEN sArea = ''
IF sCvcod = "" OR IsNull(sCvcod) THEN sCvcod = ''
IF sPdtgu = "" OR IsNull(sPdtgu) THEN sPdtgu = ''
IF sittyp = "" OR IsNull(sittyp) THEN sittyp = ''
IF sitcls = "" OR IsNull(sitcls) THEN sitcls = ''
IF sitnbr = "" OR IsNull(sitnbr) THEN sitnbr = ''
if ls_sugugb = "" or isnull(ls_sugugb) then ls_sugugb = ''
if ls_pangb = "" or isnull(ls_pangb) then ls_pangb = ''
if ls_emp_id = "" or isnull(ls_emp_id) then ls_emp_id = '%'

sNewSyntax = " AND "
sNewSyntax += "         ( SORDER.SABU = '" + gs_sabu + "' ) AND  "
/* 예상납기기간 */
//sNewSyntax += "         (( SORDER.PRE_NAPGI >= '" + sFrom + "' ) AND  "
//sNewSyntax += "         ( SORDER.PRE_NAPGI <= '" + sTo + "' )) AND  "
sNewSyntax += "         SORDER.ORDER_DATE >= '" + sord_datef + "' AND " 
sNewSyntax += "         SORDER.ORDER_DATE <= '" + sOrd_datet + "' AND  "
sNewSyntax += "         NVL(SAREA.SAREA,0) like '" + sArea + '%' + "' AND  "
If sCvcod <> '' Then sNewSyntax += "         SORDER.CVCOD = '" + sCvcod  + "' AND  "
sNewSyntax += "         SORDER.EMP_ID like '" + ls_emp_id + '%' + "' AND  "
sNewSyntax += "         ITNCT.PDTGU like '" + sPdtgu + '%' + "' AND  "
sNewSyntax += "         ITNCT.ITTYP like '" + sIttyp + '%' + "' AND  "
sNewSyntax += "         ITNCT.ITCLS like '" + sItcls + '%' + "' AND  "
sNewSyntax += "         SORDER.ITNBR like '" + sItnbr + '%' + "' AND  "
sNewSyntax += "         SORDER.SAUPJ like '" + ssaupj + '%' + "' AND  "
sNewSyntax += "         NVL(SORDER.SUGUGB,0) like '" + ls_sugugb + '%' + "' AND  "
sNewSyntax += "         NVL(SORDER.PANGB,0) like '" + ls_pangb + '%' + "' " 

nRtn = dw_print.SetSQLSelect(sSqlSyntax + sNewSyntax)

IF dw_print.Retrieve() <=0 THEN
	f_message_chk(50,'')
   dw_ip.setcolumn('sdatef')
	dw_ip.SetFocus()
	Return -1
End If

dw_print.sharedata(dw_list)

dw_print.Modify("tx_sfrom.text = '"     + string(sFrom,'@@@@.@@.@@') + "'")
dw_print.Modify("tx_sto.text = '"       + string(sTo,'@@@@.@@.@@') + "'")
dw_print.Modify("tx_ord_sfrom.text = '" + string(sord_datef,'@@@@.@@.@@') + "'")
dw_print.Modify("tx_ord_sto.text = '"   + string(sord_datet,'@@@@.@@.@@') + "'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_sarea.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_pdtgu.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ittyp) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_ittyp.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.GetitemString(1,'itclsnm'))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_itcls.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.GetitemString(1,'itdsc'))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("txt_itdsc.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(sugugb) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_sugugb.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pangb) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_pangb.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_saupj.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(emp_id) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_emp_id.text = '"+tx_name+"'")

Return 1
end function

on w_sal_02580.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rr_2
end on

on w_sal_02580.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event ue_open;call super::ue_open;dw_ip.setitem(1,"sord_datef",left(f_today(),6) +'01')
dw_ip.setitem(1,"sord_datet",left(f_today(),8))

sSqlSynTax = dw_print.GetSqlSelect()

/* 사업장 구분 */
setnull(gs_code)
f_mod_saupj(dw_ip, 'saupj')

DataWindowChild state_child
integer rtncode

//관할 구역
f_child_saupj(dw_ip, 'areacode', gs_saupj) 

//생산팀
rtncode 	= dw_ip.GetChild('pdtgu', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 생산팀")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('03',gs_saupj)

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

type p_preview from w_standard_print`p_preview within w_sal_02580
end type

type p_exit from w_standard_print`p_exit within w_sal_02580
end type

type p_print from w_standard_print`p_print within w_sal_02580
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_02580
end type

type st_window from w_standard_print`st_window within w_sal_02580
boolean visible = true
end type

type sle_msg from w_standard_print`sle_msg within w_sal_02580
boolean visible = true
end type

type dw_datetime from w_standard_print`dw_datetime within w_sal_02580
boolean visible = true
end type

type st_10 from w_standard_print`st_10 within w_sal_02580
boolean visible = true
integer width = 361
end type

type gb_10 from w_standard_print`gb_10 within w_sal_02580
boolean visible = true
end type

type dw_print from w_standard_print`dw_print within w_sal_02580
string dataobject = "d_sal_025802_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_02580
integer x = 23
integer y = 188
integer width = 4608
integer height = 280
string dataobject = "d_sal_025801"
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

event dw_ip::itemchanged;String  sIoCustArea,sDateFrom,sDateTo,snull, sJijil, sIspeccode
String  sDept, sIoCust, sIoCustName , sCvcod, scvnas, sarea, steam, sSaupj, sName1, ls_saupj, ls_pdtgu, ls_emp_id
Long    nRow, ireturn, rtncode
String  sPdtgu, sItnbr, sIttyp, sItcls, sItdsc, sIspec, sItemcls, sItemgbn, sItemclsname
datawindowchild state_child 

SetNull(snull)
setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case this.GetColumnName() 
	/* 예상납기기간 */
	Case "sdatef","sdatet"
		sDateFrom = Trim(this.GetText())
		IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
		
		IF f_datechk(sDateFrom) = -1 THEN
			f_message_chk(35,'[예상납기일자]')
			this.SetItem(1,GetColumnName(),snull)
			Return 1
		END IF
	/* 수주기간 */
	Case "sord_datef","sord_datet"
		sDateFrom = Trim(this.GetText())
		IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
		
		IF f_datechk(sDateFrom) = -1 THEN
			f_message_chk(35,'[수주기간]')
			this.SetItem(1,GetColumnName(),snull)
			Return 1
		END IF
	/* 생산팀 */
	Case "pdtgu"
		SetItem(nRow,'ittyp',sNull)
		SetItem(nRow,'itcls',sNull)
		SetItem(nRow,'itclsnm',sNull)
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
		SetItem(nRow,'ispec',sNull)
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
		
		sItemGbn = GetItemString(1,"ittyp")
		IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
			SELECT "ITNCT"."TITNM" ,"ITNCT"."PDTGU"
			  INTO :sItemClsName  , :sPdtgu
			  FROM "ITNCT"  
			 WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."ITCLS" = :sItemCls )   ;
			
			IF SQLCA.SQLCODE <> 0 THEN
				TriggerEvent(RButtonDown!)
				Return 2
			ELSE
				SetItem(1,"pdtgu",sPdtgu)
				SetItem(1,"itclsnm",sItemClsName)
			END IF
		END IF
	/* 품목명 */
	Case "itclsnm"
		SetItem(1,"itcls",snull)
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
		SetItem(nRow,'ispec',sNull)
		
		sItemClsName = GetText()
		IF sItemClsName = "" OR IsNull(sItemClsName) THEN return
			sItemGbn = GetItemString(1,"ittyp")
			IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
				SELECT "ITNCT"."ITCLS","ITNCT"."PDTGU"
				  INTO :sItemCls, :sPdtgu
				  FROM "ITNCT"  
				 WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."TITNM" = :sItemClsName )   ;
				
				IF SQLCA.SQLCODE <> 0 THEN
					TriggerEvent(RButtonDown!)
					Return 2
				ELSE
					SetItem(1,"pdtgu",sPdtgu)
					SetItem(1,"itcls",sItemCls)
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
	/* 관할구역 */
	Case "areacode"
		SetItem(1,"custcode",sNull)
		SetItem(1,"custname",sNull)
		
		sIoCustArea = this.GetText()
		IF sIoCustArea = "" OR IsNull(sIoCustArea) THEN RETURN
		
		SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sIoCustArea  ,:sDept
		  FROM "SAREA"  
		 WHERE "SAREA"."SAREA" = :sIoCustArea   ;
		
//		SetItem(1,'deptcode',sDept)

   /* 거래처 */
	Case "custcode"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"custname",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE		
			ls_saupj = dw_ip.object.saupj[1] 
			if ls_saupj = sSaupj or ls_saupj = '%' then 
				SetItem(1,"custcode",  		sCvcod)
				SetItem(1,"custname",		scvnas)
			else
				Messagebox('확인', scvnas + '[ ' + sCvcod +  ' ] 거래처에 등록된 사업장 다릅니다. ~n 사업장 정보를 확인하세요' )
				
			End if 
		END IF
	/* 거래처명 */
	Case "custname"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"custcode",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE		
			ls_saupj = dw_ip.object.saupj[1] 
			if ls_saupj = sSaupj or ls_saupj = '%' then 
				SetItem(1,"custcode",  		sCvcod)
				SetItem(1,"custname",		scvnas)
			else
				Messagebox('확인', scvnas + '[ ' + sCvcod +  ' ] 거래처에 등록된 사업장 다릅니다. ~n 사업장 정보를 확인하세요' )
				
			End if 
			Return 1
		END IF

	case 'saupj' 
		STRING ls_return, ls_sarea , ls_steam  
		ls_saupj = gettext() 
		//거래처
		sCvcod 	= this.object.custcode[1] 
		f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1)
		if ls_saupj <> ssaupj and ls_saupj <> '%' then 
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
		End if 
 
		//관할 구역
		f_child_saupj(dw_ip, 'areacode', ls_saupj)
		ls_sarea = dw_ip.object.areacode[1] 
//		ls_return = f_saupj_chk_t('1' , ls_sarea ) 
//		if ls_return <> ls_saupj and ls_saupj <> '%' then 
//				dw_ip.setitem(1, 'areacode', '')
//		End if 

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

		//생산팀
		rtncode 	= dw_ip.GetChild('pdtgu', state_child)
		IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 생산팀")
		state_child.SetTransObject(SQLCA)
		state_child.Retrieve('03',ls_saupj)
		ls_pdtgu = dw_ip.object.pdtgu[1] 
//		ls_return = f_saupj_chk_t('4' , ls_pdtgu) 
//		if ls_return <> ls_saupj and ls_saupj <> '%' then 
//				dw_ip.setitem(1, 'pdtgu', '')
//		End if 


END Choose

end event

event dw_ip::rbuttondown;string sIoCustName,sIoCustArea,sDept
string sittyp

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	Case "custcode", "custname"
		gs_gubun = '1'
		If GetColumnName() = "custname" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"custcode",gs_code)
		SetColumn("custcode")
		TriggerEvent(ItemChanged!)
//	/* 거래처 */
//	Case "custcode"
//		gs_gubun = '1'
//		Open(w_agent_popup)
//		
//		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//		
//		this.SetItem(1,"custcode",gs_code)
//		
//		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//		  INTO :sIoCustName,		:sIoCustArea,			:sDept
//		  FROM "VNDMST","SAREA" 
//		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//		IF SQLCA.SQLCODE = 0 THEN
////			this.SetItem(1,"deptcode",  sDept)
//			this.SetItem(1,"custname",  sIoCustName)
//			this.SetItem(1,"areacode",  sIoCustArea)
//		END IF
//	/* 거래처명 */
//	Case "custname"
//		gs_gubun = '1'
//		gs_codename = Trim(GetText())
//		Open(w_agent_popup)
//		
//		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//		
//		this.SetItem(1,"custcode",gs_code)
//		
//		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//		  INTO :sIoCustName,		:sIoCustArea,			:sDept
//		  FROM "VNDMST","SAREA" 
//		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//		IF SQLCA.SQLCODE = 0 THEN
////			this.SetItem(1,"deptcode",  sDept)
//			this.SetItem(1,"custname",  sIoCustName)
//			this.SetItem(1,"areacode",  sIoCustArea)
//		END IF
	Case "itcls"
		OpenWithParm(w_ittyp_popup, GetItemString(GetRow(),"ittyp"))
		
		str_sitnct = Message.PowerObjectParm	
		
		IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
		
		SetItem(1,"itcls",str_sitnct.s_sumgub)
		SetItem(1,"itclsnm", str_sitnct.s_titnm)
		SetItem(1,"ittyp",  str_sitnct.s_ittyp)
		
		SetColumn('itnbr')
	Case "itclsnm"
		OpenWithParm(w_ittyp_popup, GetItemString(GetRow(),"ittyp"))
		str_sitnct = Message.PowerObjectParm
		
		IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
		
		SetItem(1,"itcls",   str_sitnct.s_sumgub)
		SetItem(1,"itclsnm", str_sitnct.s_titnm)
		SetItem(1,"ittyp",   str_sitnct.s_ittyp)
		
		SetColumn('itnbr')
	/* ---------------------------------------- */
	Case "itnbr" ,"itdsc", "ispec"
		gs_gubun = Trim(GetItemString(1,'ittyp'))
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"itnbr",gs_code)
		SetFocus()
		SetColumn('itnbr')
		PostEvent(ItemChanged!)
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

type dw_list from w_standard_print`dw_list within w_sal_02580
integer x = 46
integer y = 512
integer width = 4544
integer height = 1820
string dataobject = "d_sal_025803"
boolean border = false
boolean hsplitscroll = false
end type

type rb_1 from radiobutton within w_sal_02580
integer x = 82
integer y = 44
integer width = 325
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "거래처별"
boolean checked = true
end type

event clicked;dw_list.SetRedraw(False)
dw_list.DataObject = 'd_sal_025802'
dw_list.SetTransObject(sqlca)
dw_print.DataObject = 'd_sal_025802_p'
dw_print.SetTransObject(sqlca)
sSqlSynTax = dw_list.GetSqlSelect()
dw_list.SetRedraw(True)
end event

type rb_2 from radiobutton within w_sal_02580
integer x = 434
integer y = 44
integer width = 283
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "제품별"
end type

event clicked;dw_list.SetRedraw(False)
dw_list.DataObject = 'd_sal_025803'
dw_print.DataObject = 'd_sal_025803_p'
dw_list.SetTransObject(sqlca)
dw_print.SetTransObject(sqlca)
sSqlSynTax = dw_list.GetSqlSelect()
dw_list.SetRedraw(True)
end event

type pb_1 from u_pb_cal within w_sal_02580
integer x = 910
integer y = 200
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sord_datef')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sord_datef', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_02580
integer x = 1376
integer y = 200
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sord_datet')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sord_datet', gs_code)
end event

type rr_1 from roundrectangle within w_sal_02580
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 504
integer width = 4571
integer height = 1836
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sal_02580
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 50
integer y = 28
integer width = 718
integer height = 112
integer cornerheight = 40
integer cornerwidth = 55
end type

