$PBExportHeader$w_sal_02560.srw
$PBExportComments$할당 현황
forward
global type w_sal_02560 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_02560
end type
type rr_3 from roundrectangle within w_sal_02560
end type
end forward

global type w_sal_02560 from w_standard_print
string title = "할당 현황"
rr_1 rr_1
rr_3 rr_3
end type
global w_sal_02560 w_sal_02560

type variables
str_itnct str_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  sArea,sitnbr,sitdsc,sAreaName,sOut_store,tx_name, sCvcod
String  sIttyp, sItcls, sOutChk, arg_chk1, arg_chk2,ssaupj ,ls_emp_id
Integer iDayCnt, nRtn

If dw_ip.AcceptText() <> 1 Then Return -1

sOut_store  = Trim(dw_ip.GetItemString(1,"depot"))
sArea   = Trim(dw_ip.GetItemString(1,"areacode"))
sIttyp  = Trim(dw_ip.GetItemString(1,"ittyp"))
sItCls  = Trim(dw_ip.GetItemString(1,"itcls"))
sItnbr  = Trim(dw_ip.GetItemString(1,"itnbr"))
sItDsc  = Trim(dw_ip.GetItemString(1,"itdsc"))
iDayCnt = dw_ip.GetItemNumber(1,"daycnt")
sOutChk = Trim(dw_ip.GetItemString(1,"outchk"))
sCvcod = Trim(dw_ip.GetItemString(1,"cvcod"))
ssaupj = dw_ip.getitemstring(1,"saupj")
ls_emp_id   = dw_ip.getitemstring(1,'emp_id')

IF sArea = "" OR IsNull(sArea) THEN sArea = ''

IF sIttyp = "" OR IsNull(sIttyp) THEN sIttyp = ''
IF sItcls = "" OR IsNull(sItcls) THEN sItcls = ''
IF sItnbr = "" OR IsNull(sItnbr) THEN sItnbr = ''
IF sCvcod = "" OR IsNull(sCvcod) THEN sCvcod = ''
if ls_emp_id = "" or isnull(ls_emp_id) then ls_emp_id = ''

IF IsNull(sOUt_store) Or sOut_store = '' THEN
	f_message_chk(30,'[창고]')
	dw_ip.SetColumn("depot")
	dw_ip.SetFocus()
	Return -1
END IF

IF IsNull(iDayCnt) THEN
	f_message_chk(30,'[할당적체일수]')
	dw_ip.SetItem(1,"daycnt",0)
	dw_ip.SetColumn("daycnt")
	dw_ip.SetFocus()
	Return -1
END IF

If IsNull(sSaupj) Or sSaupj = '' Then sSaupj = '%'
//	f_message_chk(1400,'[부가사업장]')
//	dw_ip.SetFocus()
//	Return -1
//End If

/* 송장발행 여부 :OUT_CHK - 1(할당), 2(발행) */
dw_list.SetRedraw(False)

//If sOutChk = 'A' Then
//	dw_list.DataObject = 'd_sal_025603'
//	dw_print.DataObject = 'd_sal_025603_p'
//	dw_list.SetTransObject(SQLCA)	
//	dw_print.SetTransObject(SQLCA)	
//	
//	nRtn = dw_print.Retrieve(gs_sabu, sout_store, sArea+'%', sCvcod +'%',sittyp+'%', sitcls+'%', sItnbr+'%', iDayCnt, is_today,ssaupj,ls_emp_id+'%')
//Else
	dw_list.DataObject = 'd_sal_025602'
	dw_print.DataObject = 'd_sal_025602_p'
	dw_list.SetTransObject(SQLCA)	
	dw_print.SetTransObject(SQLCA)	
	
	// 송장발행
	If sOutChk = 'Y' Then
		arg_chk1 = '2'
		arg_chk2 = '2'
	// 미발행
	ElseiF sOutChk = 'N' Then
		arg_chk1 = '1'
		arg_chk2 = '1'
	Else
		arg_chk1 = '1'
		arg_chk2 = '2'
	End If	
	
	nRtn = dw_print.Retrieve(gs_sabu, sout_store, sArea+'%', sCvcod +'%',sittyp+'%', sitcls+'%', sItnbr+'%', iDayCnt, is_today, arg_chk1, arg_chk2,ssaupj,ls_emp_id+'%' )
//End If

IF nRtn <=0 THEN
	f_message_chk(50,'')
   dw_ip.setcolumn('itnbr')
	dw_ip.SetFocus()
	dw_list.SetRedraw(True)
	Return -1
ELSE
	dw_print.ShareData(dw_list)
	
	IF sArea ='' THEN
		dw_list.Modify("txt_area.text = '전 체'")
	ELSE
		SELECT "SAREA"."SAREANM"  	INTO :sAreaName  
		  FROM "SAREA"  
   	 WHERE "SAREA"."SAREA" = :sArea   ;

		//
		dw_print.Modify("txt_area.text = '"+sAreaName+"'")
	END IF

   tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(depot) ', 1)"))
   If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
   
	dw_print.Modify("tx_depot.text = '"+tx_name+"'")
END IF

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ittyp) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("txt_ittyp.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_saupj.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(emp_id) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_emp_id.text = '"+tx_name+"'")

dw_list.SetRedraw(True)

Return 1
end function

on w_sal_02560.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_3
end on

on w_sal_02560.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_3)
end on

event ue_open;call super::ue_open;dw_ip.SetColumn("depot")
dw_ip.Setfocus()

///* User별 관할구역 Setting */
//String sarea, steam , saupj
//
//If f_check_sarea(sarea, steam, saupj) = 1 Then
//	dw_ip.SetItem(1, 'areacode', sarea)
//	dw_ip.SetItem(1, 'saupj', saupj)
//   dw_ip.Modify("areacode.protect=1")
//	dw_ip.Modify("areacode.background.color = 80859087")
//End If
//
//
///* 부가 사업장 */
//setnull(gs_code)
//If f_check_saupj() = 1 Then
//	dw_ip.SetItem(1, 'saupj', gs_code)
//	if gs_code <> '%' then
//		dw_ip.Modify("saupj.protect=1")
//		dw_ip.Modify("saupj.background.color = 80859087")
//	End if
//End If

///* 생산팀 & 영업팀 & 관할구역 Filtering */
//DataWindowChild state_child1, state_child2, state_child3
//integer rtncode1, rtncode2, rtncode3
//
//IF gs_saupj              = '10' THEN
//	rtncode1    = dw_ip.GetChild('depot', state_child1)
//	rtncode2    = dw_ip.GetChild('emp_id', state_child2)
//	rtncode3    = dw_ip.GetChild('areacode', state_child3)
//	
//	IF rtncode1 = -1 THEN MessageBox("Error1", "Not a DataWindowChild")
//	IF rtncode2 = -1 THEN MessageBox("Error2", "Not a DataWindowChild")
//	IF rtncode3 = -1 THEN MessageBox("Error3", "Not a DataWindowChild")
//	
//	state_child1.setFilter("Mid(cvcod,1,2) <> 'Z9'")
//	state_child2.setFilter("Mid(rfgub,1,1) <> 'Z' ")
//	state_child3.setFilter("sarea < '03' ")
//	
//	
//	state_child1.Filter()
//	state_child2.Filter()
//	state_child3.Filter()
//	
//ELSEIF gs_saupj      = '11' THEN
//   rtncode1    = dw_ip.GetChild('depot', state_child1)
//	rtncode2    = dw_ip.GetChild('emp_id', state_child2)
//	rtncode3    = dw_ip.GetChild('areacode', state_child3)
//	
//	IF rtncode1 = -1 THEN MessageBox("Error1", "Not a DataWindowChild")
//	IF rtncode2 = -1 THEN MessageBox("Error2", "Not a DataWindowChild")
//	IF rtncode3 = -1 THEN MessageBox("Error3", "Not a DataWindowChild")
//	
//	state_child1.setFilter("Mid(cvcod,1,2) = 'Z9'")
//	state_child2.setFilter("Mid(rfgub,1,1) = 'Z' ")
//	state_child3.setFilter("sarea > '02' ")
//	
//	
//	state_child1.Filter()
//	state_child2.Filter()
//	state_child3.Filter()
//END IF

f_mod_saupj(dw_ip, 'saupj') 

DataWindowChild state_child
integer rtncode


//영업 담당자
rtncode 	= dw_ip.GetChild('emp_id', state_child)

IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업 담당자")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('47',gs_saupj)

//출고 창고
//rtncode 	= dw_ip.GetChild('depot', state_child)
//IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 출고창고")
//state_child.SetTransObject(SQLCA)
//state_child.Retrieve(gs_saupj)

//출고 창고
f_child_saupj(dw_ip,'depot', gs_saupj)

//관할 구역
rtncode 	= dw_ip.GetChild('areacode', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 관할구역")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('%')

dw_ip.reset() 
dw_ip.insertrow(0) 
dw_ip.setitem(1, 'saupj', gs_saupj ) 


sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"

end event

type p_preview from w_standard_print`p_preview within w_sal_02560
end type

type p_exit from w_standard_print`p_exit within w_sal_02560
end type

type p_print from w_standard_print`p_print within w_sal_02560
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_02560
end type











type dw_print from w_standard_print`dw_print within w_sal_02560
integer x = 3767
integer y = 40
string dataobject = "d_sal_025602_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_02560
integer x = 32
integer y = 192
integer width = 4503
integer height = 256
string dataobject = "d_sal_025601"
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

event dw_ip::itemchanged;String  sIoCustArea,sItnbr,sItdsc,snull,sIspec, sItemCls, sItemGbn, sItemClsName, sIttyp, sItcls
String  sIocust, sIocustName, sDept , sCvcod, scvnas, sarea, steam, sSaupj, sName1,	ls_saupj
Long    rtncode 
Long    nRow
Datawindowchild state_child
SetNull(snull)

nRow = GetRow()
Choose Case GetColumnName() 
	/* 관할구역 */
	Case "areacode"
		SetItem(nRow,'cvcod',sNull)
		SetItem(nRow,'cvcodnm',sNull)
		
		sIoCustArea = this.GetText()
		IF sIoCustArea = "" OR IsNull(sIoCustArea) THEN RETURN
		
		SELECT "SAREA"."SAREA"  	INTO :sIoCustArea  
		  FROM "SAREA"  
		 WHERE "SAREA"."SAREA" = :sIoCustArea   ;
		IF SQLCA.SQLCODE <> 0 THEN
			f_message_chk(33,'[관할구역]')
			this.SetItem(1,"areacode",snull)
			Return 1
		END IF
	 /* 거래처 */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvcodnm",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvcodnm', snull)
			Return 1
		ELSE		
			SetItem(1,"cvcod",  		sCvcod)
			SetItem(1,"cvcodnm",		scvnas)			
		END IF
	/* 거래처명 */
	Case "cvcodnm"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"cvcod",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvcodnm', snull)
			Return 1
		ELSE		
			SetItem(1,"cvcod",  		sCvcod)
			SetItem(1,"cvcodnm",		scvnas)			
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
	  Case	"itnbr" 
		 sItnbr = Trim(this.GetText())
		 IF sItnbr ="" OR IsNull(sItnbr) THEN
			SetItem(nRow,'itdsc',sNull)
			SetItem(nRow,'ispec',sNull)
			Return
		 END IF
		
		 SELECT  "ITEMAS"."ITTYP", "ITEMAS"."ITCLS", "ITEMAS"."ITDSC",   "ITEMAS"."ISPEC","ITNCT"."TITNM"
			INTO :sIttyp, :sItcls, :sItdsc, :sIspec ,:sItemClsName
			FROM "ITEMAS","ITNCT"
		  WHERE "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" AND
				  "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" AND
				  "ITEMAS"."ITNBR" = :sItnbr AND
				  "ITEMAS"."USEYN" = '0' ;
	
		 IF SQLCA.SQLCODE <> 0 THEN
			this.PostEvent(RbuttonDown!)
			Return 2
		 END IF
		
		 SetItem(nRow,"ittyp", sIttyp)
		 SetItem(nRow,"itdsc", sItdsc)
		 SetItem(nRow,"ispec", sIspec)
		 SetItem(nRow,"itcls", sItcls)
		 SetItem(nRow,"itclsnm", sItemClsName)
	/* 품명 */
	  Case "itdsc"
		 sItdsc = trim(this.GetText())	
		 IF sItdsc ="" OR IsNull(sItdsc) THEN
			SetItem(nRow,'itnbr',sNull)
			SetItem(nRow,'itdsc',sNull)
			SetItem(nRow,'ispec',sNull)
			Return
		 END IF
		 
		 SELECT "ITEMAS"."ITTYP", "ITEMAS"."ITCLS", "ITEMAS"."ITNBR"
			INTO :sittyp, :sitcls, :sItnbr
			FROM "ITEMAS"  
		  WHERE "ITEMAS"."ITDSC" like :sItdsc||'%' AND "ITEMAS"."GBWAN" = 'Y' AND
			  ( "ITEMAS"."ITTYP" = '1' OR "ITEMAS"."ITTYP" = '3' OR "ITEMAS"."ITTYP" = '7' );
	
		 IF SQLCA.SQLCODE = 0 THEN
			SetItem(nRow,"itnbr",sItnbr)
			SetColumn("itnbr")
			
			TriggerEvent(ItemChanged!)
			Return 1
		ELSEIF SQLCA.SQLCODE = 100 THEN
			SetItem(nRow,'itnbr',sNull)
			SetItem(nRow,'itdsc',sNull)
			SetItem(nRow,'ispec',sNull)
			Return 1
		ELSE
			Gs_CodeName = '품명'
			Gs_Code = sItdsc
			Gs_gubun = '%'
			
			open(w_itemas_popup8)
			
			if Isnull(Gs_Code) OR Gs_Code = "" then 
			  SetItem(nRow,'itnbr',sNull)
			  SetItem(nRow,'itdsc',sNull)
			  SetItem(nRow,'ispec',sNull)
			  Return 1
			end if
			
			SetItem(nRow,"ittyp", sIttyp)
			SetItem(nRow,"itcls", sItcls)
			SetItem(nRow,"itnbr",Gs_Code)
			SetColumn("itnbr")
			SetFocus()
			
			TriggerEvent(ItemChanged!)
			Return 1
		END IF
	/* 규격 */
	 Case "ispec"
		sIspec = trim(this.GetText())	
		IF sIspec = ""	or	IsNull(sIspec)	THEN
			SetItem(nRow,'itnbr',sNull)
			SetItem(nRow,'itdsc',sNull)
			SetItem(nRow,'ispec',sNull)
			Return
		END IF
	
		SELECT "ITEMAS"."ITTYP", "ITEMAS"."ITCLS", "ITEMAS"."ITNBR"
		  INTO :sittyp, :sitcls, :sItnbr
		  FROM "ITEMAS"  
		 WHERE "ITEMAS"."ISPEC" like :sIspec||'%' AND "ITEMAS"."GBWAN" = 'Y' AND
			  ( "ITEMAS"."ITTYP" = '1' OR "ITEMAS"."ITTYP" = '3' OR "ITEMAS"."ITTYP" = '7' );
	
		IF SQLCA.SQLCODE = 0 THEN
			this.SetItem(nRow,"itnbr",sItnbr)
			this.SetColumn("itnbr")
			this.SetFocus()
			
			this.TriggerEvent(ItemChanged!)
			Return 1
		ELSEIF SQLCA.SQLCODE = 100 THEN
			SetItem(nRow,'itnbr',sNull)
			SetItem(nRow,'itdsc',sNull)
			SetItem(nRow,'ispec',sNull)
			SetColumn("ispec")
			Return 1
		ELSE
			Gs_Code = sIspec
			Gs_CodeName = '규격'
			Gs_gubun = '%'
			
			open(w_itemas_popup8)
			
			if Isnull(Gs_Code) OR Gs_Code = "" then 
			  SetItem(nRow,'itnbr',sNull)
			  SetItem(nRow,'itdsc',sNull)
			  SetItem(nRow,'ispec',sNull)
			  this.SetColumn("ispec")
			  return 1
			end if
			
			SetItem(nRow,"ittyp",sittyp)
			SetItem(nRow,"itcls",sitcls)
			SetItem(nRow,"itnbr",Gs_Code)
			SetColumn("itnbr")
			SetFocus()
			
			TriggerEvent(ItemChanged!)
			Return 1
		END IF
	case 'saupj' 
		STRING ls_return, ls_sarea , ls_steam, ls_emp_id
		ls_saupj = gettext() 
		//거래처
		sCvcod 	= this.object.cvcod[1] 
		f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1)
		if ls_saupj <> ssaupj and ls_saupj <> '%' then 
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvcodnm', snull)
		End if 
 
//		//관할 구역
//		f_child_saupj(dw_ip, 'areacode', ls_saupj)
//		ls_sarea = dw_ip.object.areacode[1] 
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

		f_child_saupj(dw_ip, 'depot', ls_saupj)
END Choose


end event

event dw_ip::rbuttondown;String sIoCustName, sIocustarea, sdept

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetcolumnName() 
	Case "cvcod", "cvcodnm"
		gs_gubun = '1'
		If GetColumnName() = "cvcodnm" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
// Case "cvcod"
//	 gs_gubun = '1'
//	 Open(w_agent_popup)
//	
//	 IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//	
//	 this.SetItem(1,"cvcod",gs_code)
//	
//	 SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//		 INTO :sIoCustName,		:sIoCustArea,			:sDept
//	   FROM "VNDMST","SAREA" 
//   	WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//	 IF SQLCA.SQLCODE = 0 THEN
//	   this.SetItem(1,"cvcodnm",  sIoCustName)
//	   this.SetItem(1,"areacode",  sIoCustArea)
//	 END IF
//Case "cvcodnm"
//	 gs_gubun = '1'
//	 gs_codename = Trim(GetText())
//	 Open(w_agent_popup)
//	
//	 IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//	
//	 this.SetItem(1,"cvcod",gs_code)
//	
//	 SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//		 INTO :sIoCustName,		:sIoCustArea,			:sDept
//	   FROM "VNDMST","SAREA" 
//   	WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//	 IF SQLCA.SQLCODE = 0 THEN
//	   this.SetItem(1,"cvcodnm",  sIoCustName)
//	   this.SetItem(1,"areacode",  sIoCustArea)
//	 END IF

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

type dw_list from w_standard_print`dw_list within w_sal_02560
integer y = 480
integer width = 4544
integer height = 1840
string dataobject = "d_sal_025602"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_02560
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer y = 184
integer width = 4590
integer height = 272
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_sal_02560
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 468
integer width = 4585
integer height = 1860
integer cornerheight = 40
integer cornerwidth = 46
end type

