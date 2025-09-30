$PBExportHeader$w_sal_02570.srw
$PBExportComments$수주미처리 현황 - 적체일수별
forward
global type w_sal_02570 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_02570
end type
end forward

global type w_sal_02570 from w_standard_print
integer width = 4663
integer height = 2512
string title = "수주미처리 현황 - 적체일수별"
boolean maxbox = true
rr_1 rr_1
end type
global w_sal_02570 w_sal_02570

type variables
str_itnct str_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  sIoGbn,sTeam,sIttyp,sItcls, tx_name,ls_steamcd,ls_sarea,ls_saleman,ssaupj , ls_pgubun ,ls_today
Long    icount, nDayCount

SetPointer(HourGlass!)
If dw_ip.AcceptText() <> 1 Then Return -1

sIoGbn = dw_ip.GetItemString(1,"sinoutgbn")
sTeam  = dw_ip.GetItemString(1,"sprodteam")
ssaupj = dw_ip.getitemstring(1,"saupj")
ls_pgubun = Trim(dw_ip.getitemstring(1,"pgubun"))
If IsNull(ls_pgubun) Then ls_pgubun = ''

nDayCount = dw_ip.GetItemNumber(1,'daycount')
If IsNull(nDayCount) Then nDayCount = 0

sIttyp = dw_ip.GetItemString(1,"ittyp")

if sittyp="" or isnull(sittyp) then
	f_message_chk(30,'[품목구분]')
	dw_ip.setcolumn("ittyp")
	return -1
end if

If IsNull(sSaupj) Or sSaupj = '' Then sSaupj = '%'
//	f_message_chk(1400,'[부가사업장]')
//	dw_ip.SetFocus()
//	Return -1
//End If

sItcls = dw_ip.GetItemString(1,"itcls")
ls_steamcd = dw_ip.getitemstring(1,"steamcd")
ls_sarea   = dw_ip.getitemstring(1,"sarea")
ls_saleman = dw_ip.getitemstring(1,"saleman")


IF sIoGbn = "A" OR sIoGbn = "" OR IsNull(sIoGbn) THEN sIoGbn = '%'
IF sTeam  = ""  OR IsNull(sTeam)  THEN sTeam = '%'


IF sIttyp = "" OR IsNull(sIttyp) THEN sIttyp = '%'
IF sItcls = "" OR IsNull(sItcls) THEN 
	sItcls = '%'
ELSE
	sItcls = Left(sItcls,4)
END IF

IF ls_steamcd  = ""  OR IsNull(ls_steamcd)  THEN ls_steamcd = '%'
IF ls_sarea  = ""  OR IsNull(ls_sarea)  THEN ls_sarea = '%'
IF ls_saleman  = ""  OR IsNull(ls_saleman)  THEN ls_saleman = '%'
ls_today = left(is_today,8)

dw_list.Reset()

//icount = dw_list.Retrieve(gs_sabu,sIoGbn,sTeam,ls_today, nDayCount, sIttyp, sItcls,ls_steamcd,ls_sarea,ls_saleman,ssaupj,ls_pgubun+'%')
icount = dw_print.Retrieve(gs_sabu,sIoGbn,sTeam,ls_today, nDayCount, sIttyp, sItcls,ls_steamcd,ls_sarea,ls_saleman,ssaupj,ls_pgubun+'%')

if icount < 1	then
	f_message_chk(50,"")
	dw_ip.setfocus()
	return -1
end if

dw_print.ShareData(dw_list)

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(sprodteam) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_sprodteam.text = '"+tx_name+"'")
dw_print.Modify("tx_sprodteam.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ittyp) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("txt_ittyp.text = '"+tx_name+"'")
dw_print.Modify("txt_ittyp.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.GetItemSTring(1,'itclsnm'))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("txt_itcls.text = '"+tx_name+"'")
dw_print.Modify("txt_itcls.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(steamcd) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_steamcd.text = '"+tx_name+"'")
dw_print.Modify("tx_steamcd.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(sarea) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_sarea.text = '"+tx_name+"'")
dw_print.Modify("tx_sarea.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saleman) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_saleman.text = '"+tx_name+"'")
dw_print.Modify("tx_saleman.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_saupj.text = '"+tx_name+"'")
dw_print.Modify("tx_saupj.text = '"+tx_name+"'")

Return 1
end function

on w_sal_02570.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_02570.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;dw_ip.SetColumn("sprodteam")
dw_ip.object.daygu[1]='1'
dw_ip.Setfocus()

///* User별 관할구역 Setting */
//String sarea, steam , saupj
//
//If f_check_sarea(sarea, steam, saupj) = 1 Then
//	dw_ip.SetItem(1, 'sarea', sarea)  //sprodteam, salesman 
//	dw_ip.SetItem(1, 'steamcd', steam)
//	dw_ip.SetItem(1, 'saupj', saupj)
//   dw_ip.Modify("sarea.protect=1")
//	dw_ip.Modify("steamcd.protect=1")
//	dw_ip.Modify("sarea.background.color = 80859087")
//	dw_ip.Modify("steamcd.background.color = 80859087")
//End If


/* 사업장 구분 */
setnull(gs_code)
f_mod_saupj(dw_ip, 'saupj')

DataWindowChild state_child
integer rtncode

//영업팀
f_child_saupj(dw_ip, 'steamcd', gs_saupj) 

//관할 구역
f_child_saupj(dw_ip, 'sarea', gs_saupj) 

//생산팀
rtncode 	= dw_ip.GetChild('sprodteam', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 생산팀")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('03',gs_saupj)

//영업담당자
rtncode 	= dw_ip.GetChild('saleman', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업담당자")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('47',gs_saupj)

//
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

type p_preview from w_standard_print`p_preview within w_sal_02570
end type

type p_exit from w_standard_print`p_exit within w_sal_02570
end type

type p_print from w_standard_print`p_print within w_sal_02570
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_02570
end type

type st_window from w_standard_print`st_window within w_sal_02570
boolean visible = true
end type

type sle_msg from w_standard_print`sle_msg within w_sal_02570
boolean visible = true
end type

type dw_datetime from w_standard_print`dw_datetime within w_sal_02570
boolean visible = true
end type

type st_10 from w_standard_print`st_10 within w_sal_02570
boolean visible = true
integer width = 361
end type

type gb_10 from w_standard_print`gb_10 within w_sal_02570
boolean visible = true
end type

type dw_print from w_standard_print`dw_print within w_sal_02570
string dataobject = "d_sal_025702_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_02570
integer x = 46
integer y = 188
integer width = 3685
integer height = 304
string dataobject = "d_sal_025701"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemchanged;String  sNull, sItemCls, sItemGbn, sItemClsName,ls_ittyp,siocustarea,sdept,ls_daygu
Long    nRow

SetNull(snull)

nRow = GetRow()
If nRow <= 0 Then Return

if dw_ip.accepttext() <> 1 then return

SetPointer(HourGlass!)

//ls_ittyp=dw_ip.getitemstring(1,"ittyp")

Choose Case GetColumnName() 
	/* 품목구분 */
	Case "ittyp"
		SetItem(nRow,'itcls',sNull)
		SetItem(nRow,'itclsnm',sNull)
	/* 품목분류 */
	Case "itcls"
		SetItem(nRow,'itclsnm',sNull)
		
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
	Case "steamcd"
		SetItem(1,'sarea',sNull)
//		SetItem(1,"custcode",sNull)
//		SetItem(1,"custname",sNull)
	/* 관할구역 */
	Case "sarea"
//		SetItem(1,"custcode",sNull)
//		SetItem(1,"custname",sNull)
		
		sIoCustArea = this.GetText()
		IF sIoCustArea = "" OR IsNull(sIoCustArea) THEN RETURN
		
		SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sIoCustArea  ,:sDept
		  FROM "SAREA"  
		 WHERE "SAREA"."SAREA" = :sIoCustArea   ;
		
		SetItem(1,'steamcd',sDept)
	case "daygu"
//		 ls_daygu=dw_ip.getitemstring(1,"daygu")
		 dw_list.setredraw(false)
//		 messagebox("",ls_daygu)
		 if Trim(GetText()) = '1' then
			dw_list.dataobject='d_sal_025702'
			dw_print.dataobject='d_sal_025702_p'
		 elseif Trim(GetText()) = '2' then
			dw_list.dataobject='d_sal_025702_1'
			dw_print.dataobject='d_sal_025702_1_p'
		 else
			dw_list.dataobject='d_sal_025703'
			dw_print.dataobject='d_sal_025703_p'
		 end if
		dw_list.settransobject(sqlca)
		dw_print.settransobject(sqlca)
		dw_list.setredraw(true)
	case 'saupj' 
		STRING ls_return, ls_sarea , ls_steam, ls_emp_id, ls_saupj, ls_pdtgu
		Long	 rtncode 
		Datawindowchild state_child
			  
		ls_saupj = gettext() 
		//관할 구역
		f_child_saupj(dw_ip, 'sarea', ls_saupj)
		ls_sarea = dw_ip.object.sarea[1] 
//		ls_return = f_saupj_chk_t('1' , ls_sarea ) 
//		if ls_return <> ls_saupj and ls_saupj <> '%' then 
//				dw_ip.setitem(1, 'sarea', '')
//		End if 
		//영업팀
		f_child_saupj(dw_ip, 'steamcd', ls_saupj) 
		ls_steam = dw_ip.object.steamcd[1] 
//		ls_return = f_saupj_chk_t('2' , ls_steam ) 
//		if ls_return <> ls_saupj and ls_saupj <> '%' then 
//				dw_ip.setitem(1, 'steamcd', '')
//		End if 

		//영업담당자
		rtncode 	= dw_ip.GetChild('salesman', state_child)
		IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업담당자")
		state_child.SetTransObject(SQLCA)
		state_child.Retrieve('47',ls_saupj)
		ls_emp_id = dw_ip.object.salesman[1] 
//		ls_return = f_saupj_chk_t('3' , ls_emp_id ) 
//		if ls_return <> ls_saupj and ls_saupj <> '%' then 
//				dw_ip.setitem(1, 'salesman', '')
//		End if 

		//생산팀
		rtncode 	= dw_ip.GetChild('sprodteam', state_child)
		IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 생산팀")
		state_child.SetTransObject(SQLCA)
		state_child.Retrieve('03',ls_saupj)
		ls_pdtgu = dw_ip.object.sprodteam[1] 
//		ls_return = f_saupj_chk_t('4' , ls_pdtgu) 
//		if ls_return <> ls_saupj and ls_saupj <> '%' then 
//				dw_ip.setitem(1, 'sprodteam', '')
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
	 
  Case "itclsnm"
	 OpenWithParm(w_ittyp_popup, this.GetItemString(this.GetRow(),"ittyp"))
    str_sitnct = Message.PowerObjectParm
	
	 IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
	
	 this.SetItem(1,"itcls",   str_sitnct.s_sumgub)
	 this.SetItem(1,"itclsnm", str_sitnct.s_titnm)
	 this.SetItem(1,"ittyp",   str_sitnct.s_ittyp)
END Choose
end event

event dw_ip::ue_key;string snull

setnull(gs_code)
SetNull(Gs_Gubun)
SetNull(Gs_codename)

setnull(snull)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itcls" OR This.GetColumnName() = "ittyp" Then
   	this.accepttext()
		gs_code = this.getitemstring(1, 'ittyp')
		
		open(w_ittyp_popup2)
		
		str_sitnct = Message.PowerObjectParm	
		
		if isnull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then 
			return
		end if
		
		this.SetItem(1,"ittyp", str_sitnct.s_ittyp)
		this.SetItem(1,"itcls", str_sitnct.s_sumgub)
		this.TriggerEvent(ItemChanged!)
	END IF
END IF

end event

type dw_list from w_standard_print`dw_list within w_sal_02570
integer x = 55
integer y = 504
integer width = 4526
integer height = 1820
string dataobject = "d_sal_025702"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_02570
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 496
integer width = 4549
integer height = 1836
integer cornerheight = 40
integer cornerwidth = 55
end type

