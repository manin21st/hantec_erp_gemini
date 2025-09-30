$PBExportHeader$w_sal_02230.srw
$PBExportComments$생산의뢰서(영업)
forward
global type w_sal_02230 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_02230
end type
type pb_2 from u_pb_cal within w_sal_02230
end type
type rr_1 from roundrectangle within w_sal_02230
end type
end forward

global type w_sal_02230 from w_standard_print
string title = "생산의뢰서(영업)"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_sal_02230 w_sal_02230

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string	syear1,syear2, sCvcodf, sCvcodt, sMax, sMin, sMaxName, sMinName,ls_pangb,tx_name, sAmtgu,ssaupj

//////////////////////////////////////////////////////////////////
If dw_ip.accepttext() <> 1 Then Return -1

syear1  = dw_ip.GetItemString(1,'syymm1')
syear2  = dw_ip.GetItemString(1,'syymm2')
sCvcodf = dw_ip.GetItemString(1,'custcode1')
sCvcodt = dw_ip.GetItemString(1,'custcode2')
ls_pangb = dw_ip.Getitemstring(1,"pangb")
sAmtGu = dw_ip.Getitemstring(1,"umgb")
ssaupj = dw_ip.getitemstring(1,"saupj")
If IsNull(sAmtgu) Or sAmtgu = 'A' then sAmtGu = ''

IF	f_datechk(syear1) <> 1 then
	f_message_chk(1400,'[승인기간]')
	dw_ip.setcolumn('syymm1')
	dw_ip.setfocus()
	Return -1
END IF

IF	f_datechk(syear2) <> 1 then
	f_message_chk(1400,'[승인기간]')
	dw_ip.setcolumn('syymm2')
	dw_ip.setfocus()
	Return -1
END IF

If IsNull(sSaupj) Or sSaupj = '' Then sSaupj = '%'
//	f_message_chk(1400,'[부가사업장]')
//	dw_ip.SetFocus()
//	Return -1
//End If

SetPointer(HourGlass!)

select max(cvcod), min(cvcod)
  into :sMax, :sMin
  from vndmst
 where saleyn = 'Y' and
       cvgu = '1';

If IsNull(sCvcodf) or Trim(scvcodf) = "" Then 
	sCvcodf = sMin
	
	select cvnas2 into :sMinName
	  from vndmst
	 where cvcod = :sCvcodf;
	 
	dw_ip.SetItem(1,'custcode1', sMin)
	dw_ip.SetItem(1,'custname1', sMinName)
End If

If IsNull(sCvcodt) or Trim(scvcodt) = "" Then 
	sCvcodt = sMax
	
	select cvnas2 into :sMaxName
	  from vndmst
	 where cvcod = :sCvcodt;
	 
	dw_ip.SetItem(1,'custcode2', sMax)
	dw_ip.SetItem(1,'custname2', sMaxName)
End If
if ls_pangb="" or isnull(ls_pangb) then
	ls_pangb='%'
end if

////////////////////////////////////////////////////////////////
dw_list.SetRedraw(False)

//if dw_list.retrieve(gs_sabu, syear1, syear2, sCvcodf, sCvcodt,ls_pangb, sAmtGu+'%',ssaupj) <= 0	then
//	f_message_chk(50,"")
//	dw_ip.setcolumn('syymm1')
//	dw_ip.setfocus()
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, syear1, syear2, sCvcodf, sCvcodt,ls_pangb, sAmtGu+'%',ssaupj) <= 0 THEN
	f_message_chk(50, '')
	dw_list.Reset()
	dw_ip.setcolumn('syymm1')
	dw_ip.setfocus()
	Return -1
END IF
			
dw_print.ShareData(dw_list)

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pangb) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_pangb.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(umgb) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_amtgu.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_saupj.text = '"+tx_name+"'")

dw_list.SetRedraw(True)

Return 1
end function

on w_sal_02230.create
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

on w_sal_02230.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;string sDate

sDate = f_today()
dw_ip.SetItem(1,'syymm1',left(sDate,6)+'01' )
dw_ip.SetItem(1,'syymm2',sDate)

dw_list.settransobject(sqlca)

/* User별 관할구역 Setting */
String sarea, steam , saupj

//If f_check_sarea(sarea, steam , saupj) = 1 Then
////	dw_ip.SetItem(1, 'ssarea', sarea)
////	dw_ip.SetItem(1, 'ssteam', steam)
//	dw_ip.SetItem(1, 'saupj', saupj)
////   dw_ip.Modify("ssarea.protect=1")
////	dw_ip.Modify("ssteam.protect=1")
////	dw_ip.Modify("ssarea.background.color = 80859087")
////	dw_ip.Modify("ssteam.background.color = 80859087")
//End If

f_mod_saupj(dw_ip, 'saupj')

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

type p_preview from w_standard_print`p_preview within w_sal_02230
end type

type p_exit from w_standard_print`p_exit within w_sal_02230
end type

type p_print from w_standard_print`p_print within w_sal_02230
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_02230
end type







type st_10 from w_standard_print`st_10 within w_sal_02230
end type



type dw_print from w_standard_print`dw_print within w_sal_02230
string dataobject = "d_sal_02230_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_02230
integer x = 23
integer y = 32
integer width = 3707
integer height = 188
string dataobject = "d_sal_022301"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String sIocust, sNull, sIoCustName , sCvcod, scvnas, sarea, steam, sSaupj, sName1, ls_saupj

SetNull(sNull)

Choose Case GetColumnName()
	/* 거래처 */
	Case "custcode1"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"custname1",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode1', sNull)
			SetItem(1, 'custname1', snull)
			Return 1
		ELSE		
			ls_saupj = dw_ip.object.saupj[1] 
			if ls_saupj = sSaupj or ls_saupj = '%' then 
				SetItem(1,"custcode1",  		sCvcod)
				SetItem(1,"custname1",		scvnas)
			else
				Messagebox('확인', scvnas + '[ ' + sCvcod +  ' ] 거래처에 등록된 사업장 다릅니다. ~n 사업장 정보를 확인하세요' )
				
			End if 
		END IF
	/* 거래처명 */
	Case "custname1"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"custcode1",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode1', sNull)
			SetItem(1, 'custname1', snull)
			Return 1
		ELSE		
			ls_saupj = dw_ip.object.saupj[1] 
			if ls_saupj = sSaupj or ls_saupj = '%' then 
				SetItem(1,"custcode1",  		sCvcod)
				SetItem(1,"custname1",		scvnas)
			else
				Messagebox('확인', scvnas + '[ ' + sCvcod +  ' ] 거래처에 등록된 사업장 다릅니다. ~n 사업장 정보를 확인하세요' )
				
			End if 
			Return 1
		END IF
	/* 거래처2 */
	Case "custcode2"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"custname2",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode2', sNull)
			SetItem(1, 'custname2', snull)
			Return 1
		ELSE		
			ls_saupj = dw_ip.object.saupj[1] 
			if ls_saupj = sSaupj or ls_saupj = '%' then 
				SetItem(1,"custcode2",  		sCvcod)
				SetItem(1,"custname2",		scvnas)
			else
				Messagebox('확인', scvnas + '[ ' + sCvcod +  ' ] 거래처에 등록된 사업장 다릅니다. ~n 사업장 정보를 확인하세요' )
				
			End if 
		END IF
	/* 거래처명2 */
	Case "custname2"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"custcode2",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode2', sNull)
			SetItem(1, 'custname2', snull)
			Return 1
		ELSE		
			ls_saupj = dw_ip.object.saupj[1] 
			if ls_saupj = sSaupj or ls_saupj = '%' then 
				SetItem(1,"custcode2",  		sCvcod)
				SetItem(1,"custname2",		scvnas)
			else
				Messagebox('확인', scvnas + '[ ' + sCvcod +  ' ] 거래처에 등록된 사업장 다릅니다. ~n 사업장 정보를 확인하세요' )
				
			End if 
			Return 1
		END IF
	Case 'saupj' 
		STRING ls_return, ls_sarea , ls_steam  
		ls_saupj = gettext() 
		//거래처
		sCvcod 	= this.object.custcode[1] 
		f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1)
		if ls_saupj <> ssaupj and ls_saupj <> '%' then 
			SetItem(1, 'custcode1', sNull)
			SetItem(1, 'custname1', snull)
			SetItem(1, 'custcode2', sNull)
			SetItem(1, 'custname2', snull)
		End if 

End Choose
end event

event dw_ip::rbuttondown;string sIoCustName,sIoCustArea,sDept

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	/* 거래처 */
   Case "custcode1", "custname1"
		gs_gubun = '1'
		If GetColumnName() = "custname1" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"custcode1",gs_code)
		SetColumn("custcode1")
		TriggerEvent(ItemChanged!)
	/* 거래처2 */
   Case "custcode2", "custname2"
		gs_gubun = '1'
		If GetColumnName() = "custname2" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"custcode2",gs_code)
		SetColumn("custcode2")
		TriggerEvent(ItemChanged!)
END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_02230
integer x = 27
integer y = 240
integer width = 4571
integer height = 2076
string dataobject = "d_sal_02230"
boolean border = false
boolean hsplitscroll = false
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type pb_1 from u_pb_cal within w_sal_02230
integer x = 818
integer y = 48
integer height = 80
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('syymm1')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'syymm1', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_02230
integer x = 1298
integer y = 48
integer height = 80
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('syymm2')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'syymm2', gs_code)

end event

type rr_1 from roundrectangle within w_sal_02230
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 232
integer width = 4594
integer height = 2100
integer cornerheight = 40
integer cornerwidth = 55
end type

