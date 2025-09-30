$PBExportHeader$w_sal_03540.srw
$PBExportComments$ ** 제품 재고 현황
forward
global type w_sal_03540 from w_standard_print
end type
type cb_1 from commandbutton within w_sal_03540
end type
type rr_1 from roundrectangle within w_sal_03540
end type
end forward

global type w_sal_03540 from w_standard_print
string title = "제품 재고 현황"
cb_1 cb_1
rr_1 rr_1
end type
global w_sal_03540 w_sal_03540

type variables
str_itnct str_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string s_saeng, s_ittyp, s_itcls, s_itnbr, s_depot,tx_name, sPangbn, sGubun

If dw_ip.accepttext() <> 1 Then Return -1

s_saeng = dw_ip.getitemstring(1,"pdtgu")
s_ittyp = dw_ip.getitemstring(1,"ittyp")
s_itcls = dw_ip.getitemstring(1,"itcls")
s_itnbr = dw_ip.getitemstring(1,"itnbr")
s_depot = dw_ip.getitemstring(1,"depot")
sPangbn = dw_ip.getitemstring(1,"pangb")
sGubun  = dw_ip.getitemstring(1,"gubun")

////필수입력항목 체크///////////////////////////////////////////////
if isnull(s_depot) or s_depot = "" then
	f_message_chk(30,'[기준창고]')
	dw_ip.setcolumn("depot")
	dw_ip.setfocus()
	return -1
end if

if isnull(s_ittyp) or s_ittyp = "" then    s_ittyp = ''
if isnull(s_saeng) or s_saeng = "" then    s_saeng = ''
if isnull(s_itcls) or s_itcls = "" then    s_itcls = ''
if isnull(s_itnbr) or s_itnbr = "" then    s_itnbr = ''
if isnull(sPangbn) or sPangbn = "" then    sPangbn = ''
if isnull(sGubun) or sGubun = "N" then    sGubun = ''

// 조회 -> 2003년 05월 30 일 수정
IF dw_print.retrieve(s_saeng+'%', s_ittyp+'%', s_itcls+'%', s_itnbr+'%', s_depot, sPangbn+'%', sGubun+'%', gs_saupj) <= 0 THEN
   f_message_chk(50,'[재고조사현황]')
	dw_ip.setfocus()
	SetPointer(Arrow!)
	Return -1
ELSE
	dw_print.ShareData(dw_list)
	
   tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
   If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
   dw_print.Modify("tx_pdtgu.text = '"+tx_name+"'")
	
   tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ittyp) ', 1)"))
   If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
   dw_print.Modify("tx_ittyp.text = '"+tx_name+"'")

	tx_name = dw_ip.GetItemString(1,'itclsnm')
   If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
	dw_print.Object.tx_itcls.Text = ''
	
	tx_name = dw_ip.GetItemString(1,'itdsc')
   If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
	dw_print.Object.tx_itnbr.Text = ''
	
   tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pangb) ', 1)"))
   If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
   dw_print.Modify("tx_pangbn.text = '"+tx_name+"'")
END IF


//// <조회> ///////////////////////////////////////////////////////////////////////////////////////////
//IF dw_list.retrieve(s_saeng+'%', s_ittyp+'%', s_itcls+'%', s_itnbr+'%', s_depot, sPangbn+'%', sGubun+'%') <= 0 THEN
//   f_message_chk(50,'[재고조사현황]')
//	dw_ip.setfocus()
//	SetPointer(Arrow!)
//	Return -1
//ELSE
//   tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
//   If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//   dw_list.Modify("tx_pdtgu.text = '"+tx_name+"'")
//	
//   tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ittyp) ', 1)"))
//   If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//   dw_list.Modify("tx_ittyp.text = '"+tx_name+"'")
//
//	tx_name = dw_ip.GetItemString(1,'itclsnm')
//   If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//	dw_list.Object.tx_itcls.Text = ''
//	
//	tx_name = dw_ip.GetItemString(1,'itdsc')
//   If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//	dw_list.Object.tx_itnbr.Text = ''
//	
//   tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pangb) ', 1)"))
//   If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//   dw_list.Modify("tx_pangbn.text = '"+tx_name+"'")
//END IF

Return 1
end function

on w_sal_03540.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_sal_03540.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;

DataWindowChild state_child
integer rtncode

//창고
rtncode 		= dw_ip.GetChild('depot', state_child)
IF rtncode 	= -1 THEN MessageBox("Error", "Not a DataWindowChild - 창고")
state_child.SetTransObject(SQLCA)
state_child.Retrieve(gs_saupj)

//생산팀
rtncode 		= dw_ip.GetChild('pdtgu', state_child)
IF rtncode 	= -1 THEN MessageBox("Error", "Not a DataWindowChild - 생산팀")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('03',gs_saupj)
dw_ip.setfocus()

dw_ip.reset() 
dw_ip.insertrow(0) 
dw_ip.setitem(1, 'saupj', gs_saupj ) 


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

type p_xls from w_standard_print`p_xls within w_sal_03540
boolean visible = true
integer x = 4270
integer y = 20
end type

type p_sort from w_standard_print`p_sort within w_sal_03540
integer x = 3922
integer y = 164
end type

type p_preview from w_standard_print`p_preview within w_sal_03540
boolean originalsize = true
end type

type p_exit from w_standard_print`p_exit within w_sal_03540
end type

type p_print from w_standard_print`p_print within w_sal_03540
boolean visible = false
integer x = 3552
integer y = 120
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_03540
end type







type st_10 from w_standard_print`st_10 within w_sal_03540
end type



type dw_print from w_standard_print`dw_print within w_sal_03540
string dataobject = "d_sal_03540_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_03540
integer x = 23
integer y = 32
integer width = 3840
integer height = 220
string dataobject = "d_sal_03540_01"
end type

event dw_ip::itemchanged;String  sNull,sPdtgu, sIttyp, sItcls, sItnbr, sItdsc, sIspec, sjijil, sispeccode
String  sItemCls, sItemGbn, sItemClsName
Long    nRow

SetNull(snull)

nRow = GetRow()
If nRow <= 0 Then Return

SetPointer(HourGlass!)

Choose Case GetColumnName() 
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
		
		SetItem(nRow,"pdtgu", sPdtgu)
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
END Choose

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

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
end event

type dw_list from w_standard_print`dw_list within w_sal_03540
integer x = 46
integer y = 320
integer width = 4535
integer height = 1928
string dataobject = "d_sal_03540_02"
boolean border = false
boolean hsplitscroll = false
end type

type cb_1 from commandbutton within w_sal_03540
boolean visible = false
integer x = 91
integer y = 80
integer width = 352
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "정렬"
end type

event clicked;openwithparm(w_report_sort, dw_list)
end event

type rr_1 from roundrectangle within w_sal_03540
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 312
integer width = 4562
integer height = 1948
integer cornerheight = 40
integer cornerwidth = 55
end type

