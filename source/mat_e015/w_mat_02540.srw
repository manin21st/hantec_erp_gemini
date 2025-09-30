$PBExportHeader$w_mat_02540.srw
$PBExportComments$**부족자재현황
forward
global type w_mat_02540 from w_standard_print
end type
type dw_list1 from datawindow within w_mat_02540
end type
type dw_list2 from datawindow within w_mat_02540
end type
type pb_1 from u_pb_cal within w_mat_02540
end type
type pb_2 from u_pb_cal within w_mat_02540
end type
type rr_1 from roundrectangle within w_mat_02540
end type
type rr_2 from roundrectangle within w_mat_02540
end type
end forward

global type w_mat_02540 from w_standard_print
string title = "부족자재현황"
dw_list1 dw_list1
dw_list2 dw_list2
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
rr_2 rr_2
end type
global w_mat_02540 w_mat_02540

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string cym, itnbr1, itnbr2, sIttyp, sgub, frdate, todate, sfilter, fpordno, tpordno, sdepot_no
string sempno, sitgu, scvcod, ls_porgu
integer cha, cha1

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

cym = Mid(f_today(),1,6)

select max(mrseq) into :cha from mtrpln_sum
 where sabu = :gs_sabu and mtryymm = :cym;
if sqlca.sqlcode <> 0 or cha < 1 then
	cha = 1
end if	

select max(moseq) into :cha1 from monpln_sum
 where sabu = :gs_sabu and monyymm = :cym;
if sqlca.sqlcode <> 0 or cha < 1 then
	cha = 1
end if	

sgub 		 = dw_ip.getitemstring(1, 'gubun' ) 
sdepot_no = dw_ip.getitemstring(1, 'depot_no' ) 
sempno	 = dw_ip.getitemstring(1, 'empno' ) 
sitgu		 = dw_ip.getitemstring(1, 'itgu' ) 
scvcod	 = dw_ip.getitemstring(1, 'cvcod' ) 
ls_porgu	 = dw_ip.getitemstring(1, 'porgu' ) 

if isnull( sdepot_no ) or trim( sdepot_no ) = '' then sDepot_no = '%';
if isnull( sempno	   ) or trim( sempno )    = '' then sempno	 = '%';
if isnull( sitgu	   ) or trim( sitgu 	)    = '' then sitgu		 = '%';
if isnull( scvcod	   ) or trim( scvcod )    = '' then scvcod	 = '%';

if sgub = '5' then  // 생산용 상세(지시별)
	fpordno = trim(dw_ip.object.fr_pordno[1])
	tpordno = trim(dw_ip.object.to_pordno[1])
	
	if (IsNull(fpordno) or fpordno = "")  then fpordno = "1000000000000000"
	if (IsNull(tpordno) or tpordno = "")  then tpordno = "9999999999999999"
	
	sittyp = trim(dw_ip.object.steam[1])
	
	dw_list.setredraw(false)

	if (sittyp = '' or isnull(sittyp))  then 
		dw_print.SetFilter("valid_qty < 0")
	else
		dw_print.SetFilter("ittyp = '"+ sittyp +"' and valid_qty < 0")
	end if	
	dw_print.Filter()
	
//	if dw_list.Retrieve(gs_sabu, cym, cha, cha1, fpordno, tpordno, sdepot_no) <= 0 then
//		f_message_chk(50,'[부족자재현황]')
//		dw_ip.Setfocus()
//		dw_list.setredraw(true)
//		return -1
//	end if

	IF dw_print.Retrieve(gs_sabu, cym, cha, cha1, fpordno, tpordno, sdepot_no ) <= 0 then
		f_message_chk(50,'[부족자재현황]')
		dw_list.Reset()
		dw_print.insertrow(0)
	//	Return -1
	END IF

	dw_print.ShareData(dw_list)

elseif sgub = '1' then  // 생산용 상세(품번별)
	itnbr1 = trim(dw_ip.object.fr_itnbr[1])
	itnbr2 = trim(dw_ip.object.to_itnbr[1])
	frdate = trim(dw_ip.object.fr_date[1])
	todate = trim(dw_ip.object.to_date[1])
	
	if (IsNull(itnbr1) or itnbr1 = "")  then itnbr1 = "."
	if (IsNull(itnbr2) or itnbr2 = "")  then itnbr2 = "ZZZZZZZZZZZZZZZ"
	
	sittyp = trim(dw_ip.object.steam[1])
	
	dw_list.setredraw(false)
	
	sfilter = "valid_qty < 0"
	
	if not (sittyp = '' or isnull(sittyp)) then 
	   sfilter = sfilter + " and ittyp = '"+ sittyp +"'" 
	end if
	if not (frdate = '' or isnull(frdate)) then 
      sfilter = sfilter + " and left(pordno,8) >= '"+ frdate +"'"
	end if	
	if not (todate = '' or isnull(todate)) then 
      sfilter = sfilter + " and left(pordno,8) <= '"+ todate +"'"
	end if	

	dw_print.SetFilter(sfilter)
	dw_print.Filter()
	
//	if dw_list.Retrieve(gs_sabu, cym, cha, cha1, itnbr1, itnbr2, sdepot_no) <= 0 then
//		f_message_chk(50,'[부족자재현황]')
//		dw_ip.Setfocus()
//		dw_list.setredraw(true)
//		return -1
//	end if

	IF dw_print.Retrieve(gs_sabu, cym, cha, cha1, itnbr1, itnbr2, sdepot_no ) <= 0 then
		f_message_chk(50,'[부족자재현황]')
		dw_list.Reset()
		dw_print.insertrow(0)
	//	Return -1
	END IF

	dw_print.ShareData(dw_list)

elseif sgub = '2' then			//  생산용요약 
	itnbr1 = trim(dw_ip.object.fr_itnbr[1])
	itnbr2 = trim(dw_ip.object.to_itnbr[1])
	
	if (IsNull(itnbr1) or itnbr1 = "")  then itnbr1 = "."
	if (IsNull(itnbr2) or itnbr2 = "")  then itnbr2 = "ZZZZZZZZZZZZZZZ"
	
	sittyp = trim(dw_ip.object.steam[1])
	
	dw_list.setredraw(false)
	
	if (sittyp = '' or isnull(sittyp))  then 
		dw_print.SetFilter("valid_qty < 0")
	else
		dw_print.SetFilter("ittyp = '"+ sittyp +"' and valid_qty < 0")
	end if	
	dw_print.Filter()
	
//	if dw_list.Retrieve(gs_sabu, cym, cha, cha1, itnbr1, itnbr2, sdepot_no) <= 0 then
//		f_message_chk(50,'[부족자재현황]')
//		dw_ip.Setfocus()
//		dw_list.setredraw(true)
//		return -1
//	end if

	IF dw_print.Retrieve(gs_sabu, cym, cha, cha1, itnbr1, itnbr2, sdepot_no ) <= 0 then
		f_message_chk(50,'[부족자재현황]')
		dw_list.Reset()
		dw_print.insertrow(0)
	//	Return -1
	END IF

	dw_print.ShareData(dw_list)

else				//  구매용상세, 구매용요약
	itnbr1 = trim(dw_ip.object.fr_itnbr[1])
	itnbr2 = trim(dw_ip.object.to_itnbr[1])
	
	if (IsNull(itnbr1) or itnbr1 = "")  then itnbr1 = "."
	if (IsNull(itnbr2) or itnbr2 = "")  then itnbr2 = "ZZZZZZZZZZZZZZZ"
	
	sittyp = trim(dw_ip.object.steam[1])
	
	dw_list.setredraw(false)
	
	if (sittyp = '' or isnull(sittyp))  then 
		dw_print.SetFilter("valid_qty < 0")
	else
		dw_print.SetFilter("ittyp = '"+ sittyp +"' and valid_qty < 0")
	end if	
	dw_print.Filter()
	
//	if dw_list.Retrieve(gs_sabu, cym, cha, cha1, itnbr1, itnbr2, sdepot_no, sempno, sitgu, scvcod) <= 0 then
//		f_message_chk(50,'[부족자재현황]')
//		dw_ip.Setfocus()
//		dw_list.setredraw(true)
//		return -1
//	end if	

	IF dw_print.Retrieve(gs_sabu, cym, cha, cha1, itnbr1, itnbr2, sdepot_no, sempno, sitgu, scvcod ) <= 0 then
		f_message_chk(50,'[부족자재현황]')
		dw_list.Reset()
		dw_print.insertrow(0)
	//	Return -1
	END IF

	dw_print.ShareData(dw_list)

end if

dw_list.setredraw(true)

return 1
end function

on w_mat_02540.create
int iCurrent
call super::create
this.dw_list1=create dw_list1
this.dw_list2=create dw_list2
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list1
this.Control[iCurrent+2]=this.dw_list2
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rr_2
end on

on w_mat_02540.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list1)
destroy(this.dw_list2)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.rr_2)
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

dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)

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

w_mdi_frame.sle_msg.text = '담당 구분이 "기타"인 창고는 재고계산에서 제외됩니다(가용재고는 외주가용포함)'
end event

event ue_open;call super::ue_open;//사업장
f_mod_saupj(dw_ip, 'porgu' )

//입고창고 
f_child_saupj(dw_ip, 'depot_no', gs_saupj)
end event

type p_preview from w_standard_print`p_preview within w_mat_02540
end type

type p_exit from w_standard_print`p_exit within w_mat_02540
end type

type p_print from w_standard_print`p_print within w_mat_02540
end type

event p_print::clicked;dw_ip.accepttext()
if dw_ip.getitemstring(1, "prtgbn") = '1' then
	gi_page = dw_list.GetItemNumber(1,"last_page")
	OpenWithParm(w_print_options, dw_list)
else
	dw_list1.print()
	dw_list2.print()
end if

end event

type p_retrieve from w_standard_print`p_retrieve within w_mat_02540
end type







type st_10 from w_standard_print`st_10 within w_mat_02540
end type



type dw_print from w_standard_print`dw_print within w_mat_02540
string dataobject = "d_mat_02540_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_mat_02540
integer x = 73
integer y = 44
integer width = 3470
integer height = 344
string dataobject = "d_mat_02540_01"
end type

event dw_ip::itemchanged;string  sitnbr, sitdsc, sispec,  snull, steam, sname, sdepot
int     ireturn
setnull(snull)
if this.getcolumnname() = 'gubun' then
	sname = gettext()
	
	if sname = '1' then
		dw_list.dataobject = 'd_mat_02540_02'		
		dw_print.dataobject = 'd_mat_02540_02_p'		
	elseif sname = '2' then
		dw_list.dataobject = 'd_mat_02540_03'
		dw_print.dataobject = 'd_mat_02540_03_p'		
	elseif sname = '3' then
		dw_list.dataobject = 'd_mat_02540_04'
		dw_print.dataobject = 'd_mat_02540_04_p'		
	elseif sname = '4' then
		dw_list.dataobject = 'd_mat_02540_05'
		dw_print.dataobject = 'd_mat_02540_05_p'				
	else
		dw_list.dataobject = 'd_mat_02540_06'
		dw_print.dataobject = 'd_mat_02540_06_p'				
	end if
	dw_list.settransobject(sqlca)	
	dw_print.settransobject(sqlca)	
	

elseif this.GetColumnName() = "prtgbn"	THEN
	sname = getitemstring(1, "gubun")
	steam = gettext()
	if steam = '1' then
		if sname = '1' then
			dw_list.dataobject = 'd_mat_02540_02'		
			dw_print.dataobject = 'd_mat_02540_02_p'		
		elseif sname = '2' then
			dw_list.dataobject = 'd_mat_02540_03'
			dw_print.dataobject = 'd_mat_02540_03_p'		
		elseif sname = '3' then
			dw_list.dataobject = 'd_mat_02540_04'
			dw_print.dataobject = 'd_mat_02540_04_p'		
		elseif sname = '4' then
			dw_list.dataobject = 'd_mat_02540_05'
			dw_print.dataobject = 'd_mat_02540_05_p'				
		else
			dw_list.dataobject = 'd_mat_02540_06'
			dw_print.dataobject = 'd_mat_02540_06_p'				
		end if
		dw_list.visible  = true
		dw_list1.visible = false
		dw_list2.visible = false
		dw_list.settransobject(sqlca)	
		dw_print.settransobject(sqlca)	

	else
		dw_list.visible  = false
		dw_list1.visible = true
		dw_list2.visible = true
		dw_list1.settransobject(sqlca)	
		dw_list2.settransobject(sqlca)
		dw_list1.retrieve(gs_sabu)
		dw_list2.retrieve(gs_sabu)
		
		p_retrieve.Enabled =false
		p_retrieve.PictureName = 'C:\erpman\image\조회_d.gif'
		
	end if
elseif this.GetColumnName() = "steam"	THEN
   steam = this.GetText()
	
   IF steam = "" OR IsNull(steam) THEN RETURN
	
	sname = f_get_reffer('05', steam)
	if isnull(sname) or sname = "" then
		f_message_chk(33,'[품목구분]')
		this.SetItem(1,'steam', snull)
		return 1
   end if	
ELSEIF this.GetColumnName() = "fr_itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "fr_itdsc"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name2('품명', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "fr_ispec"	THEN
	sIspec = trim(this.GetText())
	ireturn = f_get_name2('규격', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_itdsc"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name2('품명', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_ispec"	THEN
	sIspec = trim(this.GetText())
	ireturn = f_get_name2('규격', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "fr_date" then
	sitnbr = trim(this.GetText())
	if IsNull(sitnbr) or sitnbr = "" then return 
	if f_datechk(sitnbr) = -1 then
		f_message_chk(35, "[지시일자]")		
		this.object.fr_date[1] = ""
		return 1
	end if
ELSEIF this.GetColumnName() = "to_date" then
	sitnbr = trim(this.GetText())
	if IsNull(sitnbr) or sitnbr = "" then return 
	if f_datechk(sitnbr) = -1 then
		f_message_chk(35, "[지시일자]")		
		this.object.to_date[1] = ""
		return 1
	end if
ELSEIF this.GetColumnName() = "depot_no" then
	sitnbr = trim(this.GetText())
	if IsNull(sitnbr) or sitnbr = "" then return 
	
	select cvnas into :sname from vndmst where cvcod = :sitnbr  and cvstatus = '0';
	if sqlca.sqlcode <> 0 then
		f_message_chk(33,'[창고]')
		this.SetItem(1,'depot_no', snull)
		return 1
	end if	
ELSEIF this.GetColumnName() = "empno" then
	sitnbr = trim(this.GetText())
	if IsNull(sitnbr) or sitnbr = "" then return 
	
	select rfna1 into :sname from reffpf where rfcod = '43' and rfgub = :sitnbr;
	if sqlca.sqlcode <> 0 then
		f_message_chk(33,'[구매담당자]')
		this.SetItem(1,'empno', snull)
		return 1
	end if		
ELSEIF this.GetColumnName() = "cvcod" then
	sitnbr = trim(this.GetText())
	if IsNull(sitnbr) or sitnbr = "" then return 
	
	select cvnas into :sname from vndmst where cvcod = :sitnbr and cvstatus = '0';
	if sqlca.sqlcode <> 0 then
		f_message_chk(33,'[거래처]')
		this.SetItem(1,'cvcod', snull)
		this.SetItem(1,'cvnas', snull)
		return 1
	else
		this.setitem(1, "cvnas", sname)
	end if			
END IF
end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)

if this.GetColumnName() = 'fr_itnbr' then
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
elseif this.GetColumnName() = 'to_itnbr' then
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"to_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
ELSEIF this.getcolumnname() = "fr_pordno"	THEN		
	open(w_jisi_popup)
	if isnull(gs_code) or gs_code = "" then 	return
	this.SetItem(1, "fr_pordno", gs_code)
ELSEIF this.getcolumnname() = "to_pordno"	THEN		
	open(w_jisi_popup)
	if isnull(gs_code) or gs_code = "" then 	return
	this.SetItem(1, "to_pordno", gs_code)
ELSEIF this.getcolumnname() = "cvcod"	THEN	
	this.SetItem(1, "cvcod", gs_code)	
	this.SetItem(1, "cvnas", gs_codename)
	open(w_vndmst_popup)
	if isnull(gs_code) or gs_code = "" then 	return
	this.SetItem(1, "cvcod", gs_code)	
	this.SetItem(1, "cvnas", gs_codename)		
end if	

end event

event dw_ip::ue_key;setnull(gs_code)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "fr_itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(this.getrow(),"fr_itnbr",gs_code)
		this.TriggerEvent(ItemChanged!)
	ELSEIF This.GetColumnName() = "to_itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(this.getrow(),"to_itnbr",gs_code)
		this.TriggerEvent(ItemChanged!)
	End If
END IF

end event

type dw_list from w_standard_print`dw_list within w_mat_02540
integer x = 59
integer y = 428
integer width = 4539
integer height = 1884
string dataobject = "d_mat_02540_02"
boolean border = false
end type

type dw_list1 from datawindow within w_mat_02540
boolean visible = false
integer x = 4091
integer y = 200
integer width = 224
integer height = 148
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_mat_06400_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_list2 from datawindow within w_mat_02540
boolean visible = false
integer x = 3849
integer y = 200
integer width = 224
integer height = 148
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_mat_06400_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type pb_1 from u_pb_cal within w_mat_02540
integer x = 846
integer y = 292
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('fr_date')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'fr_date', gs_code)



end event

type pb_2 from u_pb_cal within w_mat_02540
integer x = 1298
integer y = 292
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('to_date')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'to_date', gs_code)



end event

type rr_1 from roundrectangle within w_mat_02540
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 55
integer y = 36
integer width = 3497
integer height = 360
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_mat_02540
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 420
integer width = 4567
integer height = 1900
integer cornerheight = 40
integer cornerwidth = 55
end type

