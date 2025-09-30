$PBExportHeader$w_mat_03500.srw
$PBExportComments$** 현 재고 현황
forward
global type w_mat_03500 from w_standard_print
end type
type cbx_1 from checkbox within w_mat_03500
end type
type dw_jocod from datawindow within w_mat_03500
end type
type cbx_2 from checkbox within w_mat_03500
end type
type cbx_3 from checkbox within w_mat_03500
end type
type rr_1 from roundrectangle within w_mat_03500
end type
end forward

global type w_mat_03500 from w_standard_print
integer height = 2508
string title = "현 재고 현황"
cbx_1 cbx_1
dw_jocod dw_jocod
cbx_2 cbx_2
cbx_3 cbx_3
rr_1 rr_1
end type
global w_mat_03500 w_mat_03500

forward prototypes
public subroutine wf_move (string sitnbr, string sitdsc, string sispec)
public function integer wf_retrieve ()
end prototypes

public subroutine wf_move (string sitnbr, string sitdsc, string sispec);if sitnbr = '' or isnull(sitnbr) then return 

dw_ip.setitem(1, "to_itnbr", sitnbr)	
dw_ip.setitem(1, "to_itdsc", sitdsc)	
dw_ip.setitem(1, "to_ispec", sispec)

end subroutine

public function integer wf_retrieve ();String  s_depot, s_fritnbr, s_toitnbr, s_lofr, s_loto, sgub, sgubun, sittyp, sitcls, &
        spangbn, stoday, ls_porgu
long    lRow		  

IF dw_ip.AcceptText() = -1 THEN RETURN -1

s_depot 	 = TRIM(dw_ip.GetItemString(1,"sdepot"))
sittyp 	 = TRIM(dw_ip.GetItemString(1,"ittyp"))
sitcls 	 = TRIM(dw_ip.GetItemString(1,"itcls"))
s_fritnbr = TRIM(dw_ip.GetItemString(1,"fr_itnbr"))
s_toitnbr = TRIM(dw_ip.GetItemString(1,"to_itnbr"))
s_lofr 	 = TRIM(dw_ip.GetItemString(1,"lofr"))
s_loto	 = TRIM(dw_ip.GetItemString(1,"loto"))
sgub      = dw_ip.GetItemString(1, 'gub')   //소트 순서
sgubun    = dw_ip.GetItemString(1, 'gubun') //출력구분
spangbn   = dw_ip.GetItemString(1, 'pangbn') //판매구분 
stoday    = f_today()  //현재일자

ls_porgu	 = TRIM(dw_ip.GetItemString(1,"porgu"))

if s_depot = '' or isnull(s_depot) then	s_depot = '%'
if sittyp  = '' or isnull(sittyp)  then	sittyp  = '%'

if sitcls  = '' or isnull(sitcls)  then
	sitcls  = '%'
else
	sitcls  = sitcls + '%'
end if

if spangbn = '' or isnull(spangbn) then	spangbn = '%'
IF s_fritnbr = "" OR IsNull(s_fritnbr) THEN 	s_fritnbr = '.'
IF s_toitnbr = "" OR IsNull(s_toitnbr) THEN 	s_toitnbr = 'zzzzzzzzzzzzzzz'
IF s_lofr = "" OR IsNull(s_lofr) THEN 	s_lofr = '.'
IF s_loto = "" OR IsNull(s_loto) THEN 	s_loto = 'zzzzzzzzzzzzzzz'

if sgubun = '1' then 
	if s_lofr = '.'  and s_loto = 'zzzzzzzzzzzzzzz' then
		dw_list.dataobject = 'd_mat_03500_2'
		dw_print.dataobject = 'd_mat_03500_2_p'
	else
		dw_list.dataobject = 'd_mat_03500_1'	
		dw_print.dataobject = 'd_mat_03500_1_p'
	end if
elseif sgubun = '2' then 
	dw_list.dataobject = 'd_mat_03500_3'
	dw_print.dataobject = 'd_mat_03500_3_p'
else
	dw_list.dataobject = 'd_mat_03500_4'
	dw_print.dataobject = 'd_mat_03500_4_p'
end if
dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)


// 현재고가 0 보다 작은 자료만 필터
//String ls_filter
//if cbx_1.checked then
//	dw_list.setfilter("jego_qty < 0")
//else
//	dw_list.setfilter("")
//end if
//dw_list.filter()

if sgub = '1' then 
	dw_list.SetSort("depot_no a, itnbr A, pspec a")
elseif sgub = '2' then 
	dw_list.SetSort("depot_no a, itdsc A, pspec a")
else
	dw_list.SetSort("depot_no a, stock_locfr A, stock_locto A, itnbr A," + &
						 "stock_locfr2 a, stock_locto2, pspec a")
end if
dw_list.Sort()
dw_list.GroupCalc()

if sgubun = '1' then 
	if s_lofr = '.'  and s_loto = 'zzzzzzzzzzzzzzz' then
		//IF dw_print.Retrieve(s_depot, s_fritnbr, s_toitnbr, sittyp, sitcls, spangbn, ls_porgu, gs_saupcd) <= 0 then
		IF dw_print.Retrieve(s_depot, s_fritnbr, s_toitnbr, sittyp, sitcls, spangbn, ls_porgu, ls_porgu) <= 0 then
			dw_list.Reset()
			dw_print.insertrow(0)
		//	Return -1
		END IF

	else
		//IF dw_print.Retrieve(s_depot, s_fritnbr, s_toitnbr, s_lofr, s_loto, sittyp, sitcls, spangbn, ls_porgu, gs_saupcd) <= 0 then
		IF dw_print.Retrieve(s_depot, s_fritnbr, s_toitnbr, s_lofr, s_loto, sittyp, sitcls, spangbn, ls_porgu, ls_porgu) <= 0 then
			dw_list.Reset()
			dw_print.insertrow(0)
		//	Return -1
		END IF

	end if
elseif sgubun = '2' then 
	//IF dw_print.Retrieve(s_depot, s_fritnbr, s_toitnbr, sittyp, sitcls, spangbn, ls_porgu, gs_saupcd) <= 0 then
	IF dw_print.Retrieve(s_depot, s_fritnbr, s_toitnbr, sittyp, sitcls, spangbn, ls_porgu, ls_porgu) <= 0 then
		dw_list.Reset()
		dw_print.insertrow(0)
	//	Return -1
	END IF

else
	//IF dw_print.Retrieve(gs_sabu, s_depot, s_fritnbr, s_toitnbr, sittyp, sitcls, spangbn, stoday, ls_porgu, gs_saupcd) <= 0 then
	IF dw_print.Retrieve(gs_sabu, s_depot, s_fritnbr, s_toitnbr, sittyp, sitcls, spangbn, stoday, ls_porgu, ls_porgu) <= 0 then
		dw_list.Reset()
		dw_print.insertrow(0)
	//	Return -1
	END IF

end if

dw_print.ShareData(dw_list)

String ls_use
ls_use = dw_ip.GetItemString(1, 'useyn')
If ls_use = '%' Then
	dw_list.SetFilter("")
Else
	dw_list.SetFilter("itemas_useyn = '" + ls_use + "'")
End If
dw_list.filter()

return 1

end function

on w_mat_03500.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
this.dw_jocod=create dw_jocod
this.cbx_2=create cbx_2
this.cbx_3=create cbx_3
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.dw_jocod
this.Control[iCurrent+3]=this.cbx_2
this.Control[iCurrent+4]=this.cbx_3
this.Control[iCurrent+5]=this.rr_1
end on

on w_mat_03500.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.dw_jocod)
destroy(this.cbx_2)
destroy(this.cbx_3)
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

DataWindowChild state_child
integer rtncode

//창고
rtncode 	= dw_ip.GetChild('sdepot', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 창고")
state_child.SetTransObject(SQLCA)
state_child.Retrieve(gs_saupj)

//dw_print.object.datawindow.print.preview = "yes"	
//sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"

////사업장 고정
//setnull(gs_code)
//If f_check_saupj() = 1 Then
//	dw_ip.SetItem(1, 'porgu', gs_code)
//	if gs_code <> '%' then
//		dw_ip.Modify("porgu.protect=1")
//		dw_ip.Modify("porgu.background.color = 80859087")
//	End if
//End If
dw_ip.SetItem(1, 'porgu', gs_saupj)

end event

event ue_open;call super::ue_open;//사업장
f_mod_saupj(dw_ip, 'porgu' )

//입고창고 
f_child_saupj(dw_ip, 'sdepot', gs_saupj)
end event

type p_xls from w_standard_print`p_xls within w_mat_03500
boolean visible = true
integer x = 4270
integer y = 24
end type

event p_xls::clicked;//
String ls_depot

ls_depot = dw_ip.GetItemString(1, 'sdepot')
If ls_depot = 'Z30' Then
	If MessageBox('블럭구분 포함 여부', '엑셀변환 시 블럭별 품목으로 변환하시겠습니까?', Question!, YesNo!, 1) = 1 Then
		dw_jocod.SetRedraw(False)
		dw_jocod.Retrieve('Z30', '.', 'Z', '%', '%', '%', '10')
		dw_jocod.SetRedraw(True)
		
		If This.Enabled Then wf_excel_down(dw_jocod)
		
		Return -1
	End If
	
End If

If this.Enabled Then wf_excel_down(dw_list)
end event

type p_sort from w_standard_print`p_sort within w_mat_03500
integer x = 4448
integer y = 184
end type

type p_preview from w_standard_print`p_preview within w_mat_03500
end type

type p_exit from w_standard_print`p_exit within w_mat_03500
end type

type p_print from w_standard_print`p_print within w_mat_03500
boolean visible = false
integer x = 3662
integer y = 164
end type

type p_retrieve from w_standard_print`p_retrieve within w_mat_03500
end type











type dw_print from w_standard_print`dw_print within w_mat_03500
integer x = 3781
string dataobject = "d_mat_03500_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_mat_03500
integer x = 23
integer y = 36
integer width = 3561
integer height = 368
string dataobject = "d_mat_03500_a"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::rbuttondown;string sIttyp
str_itnct lstr_sitnct

setnull(gs_gubun)
setnull(gs_code)
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
ELSEif this.GetColumnName() = 'itcls' then
	sIttyp = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp", lstr_sitnct.s_ittyp)
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
end if	

end event

event dw_ip::itemchanged;string  sitnbr, sitdsc, sispec, sdepot, sSaupj
int     ireturn

IF this.GetColumnName() = "fr_itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	wf_move(sitnbr, sitdsc, sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "fr_itdsc"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name2('품명', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	wf_move(sitnbr, sitdsc, sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "fr_ispec"	THEN
	sIspec = trim(this.GetText())
	ireturn = f_get_name2('규격', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	wf_move(sitnbr, sitdsc, sispec)
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
ELSEIF this.GetColumnName() = "gub"	THEN
	sitnbr = trim(this.GetText())
	
	if sitnbr = '1' then 
		dw_list.SetSort("depot_no A, itnbr A, pspec A")
	elseif sitnbr = '2' then 
		dw_list.SetSort("depot_no A, itdsc A, pspec A")
	else
		dw_list.SetSort("depot_no A, stock_locfr A, stock_locto A, itnbr A," + &
		                "stock_locfr2 A, stock_locto2 A,  pspec A")
	end if
	dw_list.Sort()
	dw_list.GroupCalc()
ElseIf This.GetColumnName() = 'porgu' Then
	sSaupj = Trim(This.GetText())
	//창고
	f_child_saupj(This, 'sdepot', sSaupj)
	This.SetItem(1, 'sdepot', '')
END IF
end event

event dw_ip::itemfocuschanged;call super::itemfocuschanged;Long wnd
wnd =Handle(this)

IF dwo.name ="fr_itnbr"  THEN   
	f_toggle_eng(wnd)
ELSEIF dwo.name ="to_itnbr"  THEN
	f_toggle_eng(wnd)	
END IF
end event

type dw_list from w_standard_print`dw_list within w_mat_03500
integer x = 55
integer y = 432
integer width = 4535
integer height = 1868
string dataobject = "d_mat_03500_2"
boolean border = false
end type

event dw_list::doubleclicked;call super::doubleclicked;if row <= 0 then return

gs_code = this.getitemstring(row, 'itnbr')
Open(w_bom_jego_popup)

end event

type cbx_1 from checkbox within w_mat_03500
integer x = 3653
integer y = 332
integer width = 850
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
string text = "현재고 <  0 인 자료만 표시"
end type

event clicked;if this.checked then
	dw_list.setfilter("jego_qty < 0")
else
	dw_list.setfilter("")
end if
dw_list.filter()
end event

type dw_jocod from datawindow within w_mat_03500
boolean visible = false
integer x = 3653
integer y = 44
integer width = 105
integer height = 92
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_mat_03500_2_jocod"
boolean border = false
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)

end event

type cbx_2 from checkbox within w_mat_03500
boolean visible = false
integer x = 3936
integer y = 180
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "알람 끄기"
boolean automatic = false
end type

event clicked;If This.Checked = True Then
	This.Text = '알람 켜기'
	dw_list.Modify("DataWindow.timer_interval = 0")
	dw_list.Object.itnbr.color               = "0~tif(jego_qty < minsaf, 255, 0)"
	dw_list.Object.itdsc.color               = "0~tif(jego_qty < minsaf, 255, 0)"
	dw_list.Object.aaa.color                 = "0~tif(jego_qty < minsaf, 255, 0)"
	dw_list.Object.pspec.color               = "0~tif(jego_qty < minsaf, 255, 0)"
	dw_list.Object.itgu.color                = "0~tif(jego_qty < minsaf, 255, 0)"
	dw_list.Object.minsaf.color              = "0~tif(jego_qty < minsaf, 255, 0)"
	dw_list.Object.jego_qty.color            = "0~tif(jego_qty < minsaf, 255, 0)"
	dw_list.Object.bujoc.color               = "0~tif(jego_qty < minsaf, 255, 0)"
	dw_list.Object.balju_qty.color           = "0~tif(jego_qty < minsaf, 255, 0)"
	dw_list.Object.gumde.color               = "0~tif(jego_qty < minsaf, 255, 0)"
	dw_list.Object.daegi.color               = "0~tif(jego_qty < minsaf, 255, 0)"
	dw_list.Object.stock_last_in_date.color  = "0~tif(jego_qty < minsaf, 255, 0)"
	dw_list.Object.stock_last_out_date.color = "0~tif(jego_qty < minsaf, 255, 0)"
Else
	This.Text = '알람 끄기'
	dw_list.Modify("DataWindow.timer_interval = 500")
	dw_list.Object.itnbr.color               = "0~tif(jego_qty < minsaf, if(mod(integer(Mid(string(Now()), 7, 2)), 2) = 1, 0, 255), 0)"
	dw_list.Object.itdsc.color               = "0~tif(jego_qty < minsaf, if(mod(integer(Mid(string(Now()), 7, 2)), 2) = 1, 0, 255), 0)"
	dw_list.Object.aaa.color                 = "0~tif(jego_qty < minsaf, if(mod(integer(Mid(string(Now()), 7, 2)), 2) = 1, 0, 255), 0)"
	dw_list.Object.pspec.color               = "0~tif(jego_qty < minsaf, if(mod(integer(Mid(string(Now()), 7, 2)), 2) = 1, 0, 255), 0)"
	dw_list.Object.itgu.color                = "0~tif(jego_qty < minsaf, if(mod(integer(Mid(string(Now()), 7, 2)), 2) = 1, 0, 255), 0)"
	dw_list.Object.minsaf.color              = "0~tif(jego_qty < minsaf, if(mod(integer(Mid(string(Now()), 7, 2)), 2) = 1, 0, 255), 0)"
	dw_list.Object.jego_qty.color            = "0~tif(jego_qty < minsaf, if(mod(integer(Mid(string(Now()), 7, 2)), 2) = 1, 0, 255), 0)"
	dw_list.Object.bujoc.color               = "0~tif(jego_qty < minsaf, if(mod(integer(Mid(string(Now()), 7, 2)), 2) = 1, 0, 255), 0)"
	dw_list.Object.balju_qty.color           = "0~tif(jego_qty < minsaf, if(mod(integer(Mid(string(Now()), 7, 2)), 2) = 1, 0, 255), 0)"
	dw_list.Object.gumde.color               = "0~tif(jego_qty < minsaf, if(mod(integer(Mid(string(Now()), 7, 2)), 2) = 1, 0, 255), 0)"
	dw_list.Object.daegi.color               = "0~tif(jego_qty < minsaf, if(mod(integer(Mid(string(Now()), 7, 2)), 2) = 1, 0, 255), 0)"
	dw_list.Object.stock_last_in_date.color  = "0~tif(jego_qty < minsaf, if(mod(integer(Mid(string(Now()), 7, 2)), 2) = 1, 0, 255), 0)"
	dw_list.Object.stock_last_out_date.color = "0~tif(jego_qty < minsaf, if(mod(integer(Mid(string(Now()), 7, 2)), 2) = 1, 0, 255), 0)"
End If
end event

type cbx_3 from checkbox within w_mat_03500
integer x = 3653
integer y = 252
integer width = 823
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
string text = "부족재고 > 0 인 자료만 표시"
end type

event clicked;if this.checked then
	dw_list.setfilter("(minsaf-jego_qty) > 0")
else
	dw_list.setfilter("")
end if
dw_list.filter()
end event

type rr_1 from roundrectangle within w_mat_03500
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 420
integer width = 4576
integer height = 1892
integer cornerheight = 40
integer cornerwidth = 55
end type

