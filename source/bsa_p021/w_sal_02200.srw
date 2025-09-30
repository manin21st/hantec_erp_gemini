$PBExportHeader$w_sal_02200.srw
$PBExportComments$납품 진행 현황- 거래처별
forward
global type w_sal_02200 from w_standard_print
end type
type rb_1 from radiobutton within w_sal_02200
end type
type rb_2 from radiobutton within w_sal_02200
end type
type pb_1 from u_pb_cal within w_sal_02200
end type
type pb_2 from u_pb_cal within w_sal_02200
end type
type rr_1 from roundrectangle within w_sal_02200
end type
type rr_2 from roundrectangle within w_sal_02200
end type
type rr_3 from roundrectangle within w_sal_02200
end type
type rr_4 from roundrectangle within w_sal_02200
end type
end forward

global type w_sal_02200 from w_standard_print
string title = "납품 진행 현황"
rb_1 rb_1
rb_2 rb_2
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
rr_4 rr_4
end type
global w_sal_02200 w_sal_02200

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string s_cvcod, s_datef,s_datet, sdeptcode, sareacode, sPrtgbn, tx_name,ssaupj ,ls_emp_id
String sDatef, sDatet ,sIttyp, sItcls, sItnbr, sPspec,ls_sarea, sfacgbn

If dw_ip.accepttext() <> 1 Then Return -1

if rb_1.checked= true then
			s_datef = dw_ip.getitemstring(1,"sdatef")
			s_datet = dw_ip.getitemstring(1,"sdatet")
			s_cvcod = dw_ip.getitemstring(1,"custcode")
			sdeptcode = dw_ip.getitemstring(1,"deptcode")
			sareacode = dw_ip.getitemstring(1,"areacode")
			sPrtgbn   = dw_ip.getitemstring(1,"prtgbn")
			ssaupj = dw_ip.getitemstring(1,"saupj")
			ls_emp_id  = dw_ip.getitemstring(1,'emp_id')
			
			//필수입력항목 체크///////////////////////////////////
			if f_datechk(s_datef) <> 1 Or f_datechk(s_datet) <> 1 then
				f_message_chk(30,'[출고기간]')
				dw_ip.setfocus()
				return -1
			end if
			
			If IsNull(sSaupj) Or sSaupj = '' Then sSaupj = '%'
//				f_message_chk(1400,'[부가사업장]')
//				dw_ip.SetFocus()
//				Return -1
//			End If
			
			If IsNull(s_cvcod ) Then s_cvcod = ''
			If IsNull(sdeptcode ) Then sdeptcode = ''
			If IsNull(sareacode ) Then sareacode = ''
			if ls_emp_id = "" or isnull(ls_emp_id) then ls_emp_id = '%'
			
			dw_list.SetRedraw(False)
			
			//조회////////////////////////////////////////////////
			IF dw_list.retrieve(gs_sabu, s_datef, s_datet, sdeptcode+'%',sareacode+'%',s_cvcod+'%',ssaupj,ls_emp_id) <= 0 THEN
				f_message_chk(50,'')
				dw_list.SetRedraw(True)
				Return -1
			END IF
			
			/* 진행여부에 따라 */
			Choose Case sPrtgbn
				Case '0'
					dw_list.SetFilter("IsNull(yebi1)")
					dw_list.Modify("txt_prtgbn.text = '진행'")
				Case '1'
					dw_list.SetFilter("Not IsNull(yebi1)")
					dw_list.Modify("txt_prtgbn.text = '완료'")
				Case '2'
					dw_list.SetFilter("")
					dw_list.Modify("txt_prtgbn.text = '전체'")
			End Choose
			dw_list.Filter()
			
			tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
			If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
			dw_list.Modify("txt_steamcd.text = '"+tx_name+"'")
			
			tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
			If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
			dw_list.Modify("txt_sarea.text = '"+tx_name+"'")
			
			tx_name = Trim(dw_ip.GetItemString(1,'custname'))
			If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
			dw_list.Modify("txt_cvcod.text = '"+tx_name+"'")
			
			tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
			If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
			dw_list.Modify("tx_saupj.text = '"+tx_name+"'")
			
			tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(emp_id) ', 1)"))
			If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
			dw_list.Modify("tx_emp_id.text = '"+tx_name+"'")
else
			sDatef      = Trim(dw_ip.GetItemString(1,"sdatef"))
			sDatet      = Trim(dw_ip.GetItemString(1,"sdatet"))
			sIttyp      = Trim(dw_ip.GetItemString(1,"ittyp"))
			sItcls      = Trim(dw_ip.GetItemString(1,"itcls"))
			sItnbr      = Trim(dw_ip.GetItemString(1,"itnbr"))
			sPrtgbn     = Trim(dw_ip.GetItemString(1,"prtgbn"))
			ls_sarea    = Trim(dw_ip.GetItemString(1,"sarea"))
			ssaupj      = dw_ip.getitemstring(1,"saupj")
			ls_emp_id   = dw_ip.getitemstring(1,'emp_id')
			sfacgbn     = dw_ip.getitemstring(1,'plnt')
			
			IF sDatef = "" OR IsNull(sDatef) or sDatet = "" OR IsNull(sDatet) THEN
				f_message_chk(30,'[기간]')
				dw_ip.SetColumn("sdatef")
				dw_ip.SetFocus()
				Return -1
			END IF
			
			If IsNull(sSaupj) Or sSaupj = '' Then sSaupj = '%'
//				f_message_chk(1400,'[부가사업장]')
//				dw_ip.SetFocus()
//				Return -1
//			End If
			
			If Isnull(sIttyp) Then sIttyp = ''
			If Isnull(sItcls) Then sItcls = ''
			If Isnull(sItnbr) Then sItnbr = ''
			if isnull(ls_sarea) then ls_sarea = ''
			if ls_emp_id = "" or isnull(ls_emp_id) then ls_emp_id = '%'
			if sfacgbn = "" or isnull(sfacgbn) then sfacgbn = '%'
			
			/* 진행여부에 따라 */
			Choose Case sPrtgbn
				Case '0'
					dw_list.SetFilter("IsNull(yebi1)")
					dw_list.Modify("txt_prtgbn.text = '진행'")
				Case '1'
					dw_list.SetFilter("Not IsNull(yebi1)")
					dw_list.Modify("txt_prtgbn.text = '완료'")
				Case '2'
					dw_list.SetFilter("")
					dw_list.Modify("txt_prtgbn.text = '전체'")
			End Choose
			dw_list.Filter()
			
			dw_list.SetRedraw(False)
			IF dw_list.Retrieve(gs_sabu,sdatef, sdatet, sIttyp+'%',sItcls+'%',sItnbr+'%',ls_sarea+'%',ssaupj,ls_emp_id, sfacgbn) <=0 THEN
				f_message_chk(50,'')
				dw_ip.setcolumn('sdatef')
				dw_ip.SetFocus()
				dw_list.SetRedraw(True)
				Return -1
			END IF
			
			tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ittyp) ', 1)"))
			If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
			dw_list.Modify("txt_ittyp.text = '"+tx_name+"'")
			
			tx_name = Trim(dw_ip.GetitemString(1,'itclsnm'))
			If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
			dw_list.Modify("txt_itcls.text = '"+tx_name+"'")
			
			tx_name = Trim(dw_ip.GetitemString(1,'itdsc'))
			If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
			dw_list.Modify("txt_itnbr.text = '"+tx_name+"'")
			
			tx_name = Trim(dw_ip.GetitemString(1,'sarea'))
			If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
			dw_list.Modify("tx_sarea.text = '"+tx_name+"'")
			
			tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
			If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
			dw_list.Modify("tx_saupj.text = '"+tx_name+"'")
			
			tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(emp_id) ', 1)"))
			If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
			dw_list.Modify("tx_emp_id.text = '"+tx_name+"'")
	
end if

dw_list.ShareData(dw_print)
dw_list.SetRedraw(True)

Return 0
end function

on w_sal_02200.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rr_2
this.Control[iCurrent+7]=this.rr_3
this.Control[iCurrent+8]=this.rr_4
end on

on w_sal_02200.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_4)
end on

event ue_open;call super::ue_open;/* User별 관할구역 Setting */
String sarea, steam , saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.SetItem(1, 'areacode', sarea)
	dw_ip.SetItem(1, 'deptcode', steam)
	dw_ip.SetItem(1, 'saupj', saupj)
   dw_ip.Modify("areacode.protect=1")
	dw_ip.Modify("deptcode.protect=1")
	dw_ip.Modify("areacode.background.color = 80859087")
	dw_ip.Modify("deptcode.background.color = 80859087")
End If

/* 부가 사업장 */
setnull(gs_code)
f_mod_saupj(dw_ip, 'saupj')
DataWindowChild state_child
integer rtncode
  
//영업팀
rtncode 	= dw_ip.GetChild('deptcode', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업팀")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('%')

//관할 구역
rtncode 	= dw_ip.GetChild('areacode', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 관할구역")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('%')

//영업 담당자
rtncode 	= dw_ip.GetChild('emp_id', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업 담당자")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('47',gs_saupj)

dw_ip.SetItem(1,"sdatef", Left(is_today,6)+'01')
dw_ip.SetItem(1,"sdatet", is_today)

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"
end event

type p_preview from w_standard_print`p_preview within w_sal_02200
end type

type p_exit from w_standard_print`p_exit within w_sal_02200
end type

type p_print from w_standard_print`p_print within w_sal_02200
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_02200
end type







type st_10 from w_standard_print`st_10 within w_sal_02200
end type



type dw_print from w_standard_print`dw_print within w_sal_02200
string dataobject = "d_sal_022001_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_02200
integer x = 82
integer y = 220
integer width = 4466
integer height = 172
string dataobject = "d_sal_02200_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  sIoCust, sIoCustArea, sIoCustName, sDept, sDeptname, sJijil, sIspeccode
String  sDateFrom, sDateTo, snull, sPrtGbn
String  sPdtgu, sIttyp, sItcls, sItnbr, sItdsc, sIspec
String  sItemCls, sItemGbn, sItemClsName , sCvcod, scvnas, sarea, steam, sSaupj, sName1, scode
Long    nRow
String ls_saupj, ls_sarea, ls_return, ls_steam, ls_emp_id, ls_pdtgu
long rtncode 
Datawindowchild state_child 

SetNull(snull)

IF RB_1.CHECKED = TRUE THEN

		Choose Case GetColumnName() 
			Case"sdatef"
				sDateFrom = Trim(this.GetText())
				IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
				
				IF f_datechk(sDateFrom) = -1 THEN
					f_message_chk(35,'[출고기간]')
					this.SetItem(1,"sdatef",snull)
					Return 1
				END IF
			Case "sdatet"
				sDateTo = Trim(this.GetText())
				IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
				
				IF f_datechk(sDateTo) = -1 THEN
					f_message_chk(35,'[출고기간]')
					this.SetItem(1,"sdatet",snull)
					Return 1
				END IF
			/* 영업팀 */
			Case "deptcode"
				SetItem(1,'areacode',sNull)
				SetItem(1,"custcode",sNull)
				SetItem(1,"custname",sNull)
			/* 관할구역 */
			Case "areacode"
				SetItem(1,"custcode",sNull)
				SetItem(1,"custname",sNull)
				
				sIoCustArea = this.GetText()
				IF sIoCustArea = "" OR IsNull(sIoCustArea) THEN RETURN
				
				SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sIoCustArea  ,:sDept
				  FROM "SAREA"  
				 WHERE "SAREA"."SAREA" = :sIoCustArea   ;
				
				SetItem(1,'deptcode',sDept)
			
			Case "custcode"
				sCvcod = Trim(GetText())
				IF 	sCvcod ="" OR IsNull(sCvcod) THEN
					SetItem(1,"custname",snull)
					Return
				END IF
		
				If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
					SetItem(1, 'custcode', sNull)
					SetItem(1, 'custname', snull)
					Return 1
				ELSE		
					SetItem(1,"deptcode",   steam)
					SetItem(1,"custname", scvnas)
					SetItem(1,"emp_id",   sname1)					
				END IF
				
			/* 거래처명 */
			Case "custname"
				scvnas = Trim(GetText())
				If 	f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
					SetItem(1, 'custcode', sNull)
					SetItem(1, 'custname', snull)
					Return 1
				ELSE		
					SetItem(1,"deptcode",   steam)
					SetItem(1,'custcode', sCvcod)
					SetItem(1,"custname", scvnas)
					SetItem(1,"areacode",   sarea)
					SetItem(1,"emp_id",   sname1)					
				END IF
		
		
			case 'saupj' 
				
				//거래처
				ls_saupj = gettext() 
				sCode 	= this.object.custcode[1] 
				f_get_cvnames('1', sCode, scvnas, sarea, steam, sSaupj, sName1)
				if ls_saupj <> ssaupj and ls_saupj <> '%' then 
					SetItem(1, 'custcode', sNull)
					SetItem(1, 'custname', snull)
				End if 
//				//관할 구역
//				f_child_saupj(dw_ip, 'areacode', ls_saupj)
//				ls_sarea = dw_ip.object.areacode[1] 
//				ls_return = f_saupj_chk_t('1' , ls_sarea ) 
//				if ls_return <> ls_saupj and ls_saupj <> '%' then 
//						dw_ip.setitem(1, 'areacode', '')
//				End if 
//				//영업팀
//				f_child_saupj(dw_ip, 'deptcode', ls_saupj) 
//				ls_steam = dw_ip.object.deptcode[1] 
//				ls_return = f_saupj_chk_t('2' , ls_steam ) 
//				if ls_return <> ls_saupj and ls_saupj <> '%' then 
//						dw_ip.setitem(1, 'deptcode', '')
//				End if 
				
				//영업 담당자
				rtncode 	= dw_ip.GetChild('emp_id', state_child)
				IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업 담당자")
				state_child.SetTransObject(SQLCA)
				state_child.Retrieve('47',ls_saupj)
				ls_emp_id = dw_ip.object.emp_id[1]
				ls_return = f_saupj_chk_t('3' , ls_emp_id ) 
				if ls_return <> ls_saupj and ls_saupj <> '%' then 
						dw_ip.setitem(1, 'emp_id', '')
				End if 
		
				Case 'prtgbn'
				Choose Case GetText()
					Case '0'
						dw_list.SetFilter("IsNull(yebi1)")
						dw_list.Modify("txt_prtgbn.text = '진행'")
					Case '1'
						dw_list.SetFilter("Not IsNull(yebi1)")
						dw_list.Modify("txt_prtgbn.text = '완료'")
					Case '2'
						dw_list.SetFilter("")
						dw_list.Modify("txt_prtgbn.text = '전체'")
				End Choose
				dw_list.Filter()
		END Choose
ELSE
		nRow = GetRow()
		If nRow <= 0 Then Return
		
		Choose Case GetColumnName() 
			Case"sdatef"
				sDateFrom = Trim(this.GetText())
				IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
				
				IF f_datechk(sDateFrom) = -1 THEN
					f_message_chk(35,'[수불기간]')
					this.SetItem(1,"sdatef",snull)
					Return 1
				END IF
			Case "sdatet"
				sDateTo = Trim(this.GetText())
				IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
				
				IF f_datechk(sDateTo) = -1 THEN
					f_message_chk(35,'[수불기간]')
					this.SetItem(1,"sdatet",snull)
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
		//				SetItem(1,"pdtgu",sPdtgu)
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
		//					SetItem(1,"pdtgu",sPdtgu)
							SetItem(1,"itcls",sItemCls)
					END IF
				END IF
			/* 품번 */
			Case	"itnbr" 
				sItnbr = Trim(GetText())
				IF sItnbr ="" OR IsNull(sItnbr) THEN
					SetItem(nRow,'itdsc',sNull)
					SetItem(nRow,'ispec',sNull)
					Return
				END IF
				
				SELECT "ITEMAS"."ITTYP", "ITEMAS"."ITCLS", "ITEMAS"."ITDSC",
						 "ITEMAS"."ISPEC","ITNCT"."TITNM", "ITNCT"."PDTGU"
				  INTO :sIttyp, :sItcls, :sItdsc, :sIspec ,:sItemClsName,:sPdtgu
				  FROM "ITEMAS","ITNCT"
				 WHERE "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" AND
						 "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" AND
						 "ITEMAS"."ITNBR" = :sItnbr ;
				
				IF SQLCA.SQLCODE <> 0 THEN
					PostEvent(RbuttonDown!)
					Return 2
				END IF
				
		//		SetItem(nRow,"pdtgu", sPdtgu)
				SetItem(nRow,"ittyp", sIttyp)
				SetItem(nRow,"itdsc", sItdsc)
				SetItem(nRow,"ispec", sIspec)
				SetItem(nRow,"itcls", sItcls)
				SetItem(nRow,"itclsnm", sItemClsName)
			/* 품명 */
			Case "itdsc"
				sItdsc = trim(GetText())	
				IF sItdsc ="" OR IsNull(sItdsc) THEN
					SetItem(nRow,'itnbr',sNull)
					SetItem(nRow,'itdsc',sNull)
					SetItem(nRow,'ispec',sNull)
					Return
				END IF
				
				/* 품명으로 품번찾기 */
				f_get_name4('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
				If IsNull(sItnbr ) Then
					Return 1
				ElseIf sItnbr <> '' Then
					SetItem(nRow,"itnbr",sItnbr)
					SetColumn("itnbr")
					SetFocus()
					TriggerEvent(ItemChanged!)
					Return 1
				ELSE
					SetItem(nRow,'itnbr',sNull)
					SetItem(nRow,'itdsc',sNull)
					SetItem(nRow,'ispec',sNull)
					SetColumn("itdsc")
					Return 1
				End If	
			/* 규격 */
			Case "ispec"
				sIspec = trim(GetText())	
				IF sIspec = ""	or	IsNull(sIspec)	THEN
					SetItem(nRow,'itnbr',sNull)
					SetItem(nRow,'itdsc',sNull)
					SetItem(nRow,'ispec',sNull)
					Return
				END IF
				
				/* 규격으로 품번찾기 */
				f_get_name4('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
				If IsNull(sItnbr ) Then
					Return 1
				ElseIf sItnbr <> '' Then
					SetItem(nRow,"itnbr",sItnbr)
					SetColumn("itnbr")
					SetFocus()
					TriggerEvent(ItemChanged!)
					Return 1
				ELSE
					SetItem(nRow,'itnbr',sNull)
					SetItem(nRow,'itdsc',sNull)
					SetItem(nRow,'ispec',sNull)
					SetColumn("ispec")
					Return 1
				End If
			Case 'prtgbn'
				Choose Case GetText()
					Case '0'
						dw_list.SetFilter("IsNull(yebi1)")
						dw_list.Modify("txt_prtgbn.text = '진행'")
					Case '1'
						dw_list.SetFilter("Not IsNull(yebi1)")
						dw_list.Modify("txt_prtgbn.text = '완료'")
					Case '2'
						dw_list.SetFilter("")
						dw_list.Modify("txt_prtgbn.text = '전체'")
				End Choose
				dw_list.Filter()
				dw_list.SetSort('imhist_itnbr, imhist_io_date, yebi1')
				dw_list.Sort()
				dw_list.GroupCalc()
		END Choose
END IF
end event

event dw_ip::rbuttondown;string sIoCustName,sIoCustArea,sDept

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

str_itnct str_sitnct 

IF RB_1.CHECKED = TRUE THEN

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
//			/* 거래처 */
//			Case "custcode"
//				gs_gubun = '1'
//				Open(w_agent_popup)
//				
//				IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//				
//				this.SetItem(1,"custcode",gs_code)
//				
//				SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//				  INTO :sIoCustName,		:sIoCustArea,			:sDept
//				  FROM "VNDMST","SAREA" 
//				 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//				IF SQLCA.SQLCODE = 0 THEN
//					this.SetItem(1,"deptcode",  sDept)
//					this.SetItem(1,"custname",  sIoCustName)
//					this.SetItem(1,"areacode",  sIoCustArea)
//				END IF
//			/* 거래처명 */
//			Case "custname"
//				gs_gubun = '1'
//				gs_codename = Trim(GetText())
//				Open(w_agent_popup)
//				
//				IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//				
//				this.SetItem(1,"custcode",gs_code)
//				
//				SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//				  INTO :sIoCustName,		:sIoCustArea,			:sDept
//				  FROM "VNDMST","SAREA" 
//				 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//				IF SQLCA.SQLCODE = 0 THEN
//					this.SetItem(1,"deptcode",  sDept)
//					this.SetItem(1,"custname",  sIoCustName)
//					this.SetItem(1,"areacode",  sIoCustArea)
//				END IF
		END Choose
ELSE
		Choose Case GetcolumnName() 
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
END IF			
end event

type dw_list from w_standard_print`dw_list within w_sal_02200
integer x = 23
integer y = 444
integer width = 4544
integer height = 1880
string dataobject = "d_sal_022001"
boolean border = false
end type

type rb_1 from radiobutton within w_sal_02200
integer x = 55
integer y = 76
integer width = 370
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "거래처별"
boolean checked = true
end type

event clicked;dw_ip.setredraw(false)
dw_ip.dataobject = 'd_sal_02200_01'
dw_ip.settransobject(sqlca)
dw_ip.insertrow(1)
dw_ip.setitem(1,'sdatef',left(f_today(),6) + '01')
dw_ip.setitem(1,'sdatet',left(f_today(),8))
dw_ip.setredraw(true)

dw_list.setredraw(false)
dw_list.dataobject = 'd_sal_022001'
dw_print.dataobject = 'd_sal_022001_p'
dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)
dw_list.setredraw(true)

dw_ip.setcolumn('sdatef')

/* User별 관할구역 Setting */
String sarea, steam , saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.SetItem(1, 'areacode', sarea)
	dw_ip.SetItem(1, 'deptcode', steam)
	dw_ip.SetItem(1, 'saupj', saupj)
   dw_ip.Modify("areacode.protect=1")
	dw_ip.Modify("deptcode.protect=1")
End If

/* 부가 사업장 */
setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_ip.SetItem(1, 'saupj', gs_code)
	if gs_code <> '%' then
		dw_ip.Modify("saupj.protect=1")
		dw_ip.Modify("saupj.background.color = 80859087")
	End if
End If


p_preview.Enabled = False
p_print.Enabled = False
p_preview.PictureName= "C:\erpman\image\미리보기_d.gif"
p_print.PictureName = "C:\erpman\image\인쇄_d.gif"
end event

type rb_2 from radiobutton within w_sal_02200
integer x = 434
integer y = 76
integer width = 315
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "제품별"
end type

event clicked;dw_ip.setredraw(false)
dw_ip.dataobject = 'd_sal_022003'
dw_ip.settransobject(sqlca)
dw_ip.insertrow(1)
dw_ip.setitem(1,'sdatef',left(f_today(),6) + '01')
dw_ip.setitem(1,'sdatet',left(f_today(),8))
dw_ip.setredraw(true)

dw_list.setredraw(false)
dw_list.dataobject = 'd_sal_022002'
dw_print.dataobject = 'd_sal_022002_p'
dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)
dw_list.setredraw(true)

dw_ip.setcolumn('sdatef')

/* User별 관할구역 Setting */
String sarea, steam , saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.SetItem(1, 'saupj', saupj)
End If

/* 부가 사업장 */
setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_ip.SetItem(1, 'saupj', gs_code)
	if gs_code <> '%' then
		dw_ip.Modify("saupj.protect=1")
		dw_ip.Modify("saupj.background.color = 80859087")
	End if
End If

p_preview.Enabled = False
p_print.Enabled = False
p_preview.PictureName= "C:\erpman\image\미리보기_d.gif"
p_print.PictureName = "C:\erpman\image\인쇄_d.gif"
end event

type pb_1 from u_pb_cal within w_sal_02200
integer x = 777
integer y = 232
integer height = 80
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

type pb_2 from u_pb_cal within w_sal_02200
integer x = 1230
integer y = 232
integer height = 80
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

type rr_1 from roundrectangle within w_sal_02200
integer linethickness = 1
long fillcolor = 16777215
integer x = 142
integer y = 236
integer width = 165
integer height = 144
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_sal_02200
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 32
integer y = 196
integer width = 4590
integer height = 216
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_sal_02200
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 428
integer width = 4581
integer height = 1900
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_4 from roundrectangle within w_sal_02200
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 32
integer y = 36
integer width = 741
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

