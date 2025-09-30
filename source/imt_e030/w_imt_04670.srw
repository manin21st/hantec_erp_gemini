$PBExportHeader$w_imt_04670.srw
$PBExportComments$** 매입마감 현황
forward
global type w_imt_04670 from w_standard_print
end type
type dw_1 from datawindow within w_imt_04670
end type
type rr_1 from roundrectangle within w_imt_04670
end type
type rr_2 from roundrectangle within w_imt_04670
end type
type rr_3 from roundrectangle within w_imt_04670
end type
end forward

global type w_imt_04670 from w_standard_print
string title = "매입 마감 현황"
dw_1 dw_1
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_imt_04670 w_imt_04670

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string gubun, ym, cvcod1, cvcod2, sempno1, sempno2, sgubun, swaigu, ssaupj, cvcod
Long i_rtn, seq

if dw_1.AcceptText() = -1 then
	dw_1.SetFocus()
	return -1
end if	

gubun = Trim(dw_1.object.gubun[1])

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

ym = Trim(dw_ip.object.ym[1])

if gubun = '1' or gubun = '4' or gubun = '5' then
	ssaupj = dw_ip.object.saupj[1]
end if	

if gubun = '1' or gubun = '2' or gubun = '3' then
	sempno1 = Trim(dw_ip.object.empno1[1])
	sempno2 = Trim(dw_ip.object.empno2[1])
	sgubun  = Trim(dw_ip.object.gubun[1])
end if

if IsNull(sempno1) or sempno1 = "" then sempno1 = "."
if IsNull(sempno2) or sempno2 = "" then sempno2 = "ZZZZZZ"

if IsNull(ym) or ym = "" then 
	f_message_chk(30, "[마감년월]")
	dw_ip.setcolumn('ym')
	dw_ip.setfocus()
	return -1
end if	

if gubun <> '2' then 
	cvcod1 = Trim(dw_ip.object.cvcod1[1])
	cvcod2 = Trim(dw_ip.object.cvcod2[1])
	if IsNull(cvcod1) or cvcod1 = "" then cvcod1 = "."
	if IsNull(cvcod2) or cvcod2 = "" then cvcod2 = "ZZZZZZ"
Else
	cvcod = Trim(dw_ip.object.cvcod[1])
	if IsNull(cvcod) or cvcod = "" then cvcod = "%"
end if

if gubun = "2" or gubun = "3" then 	
//   seq = dw_ip.object.seq[1]
//	if IsNull(seq) or seq = 0 then 
//		f_message_chk(30, "[마감차수]")
//		dw_ip.setcolumn('seq')
//		dw_ip.setfocus()
//		return -1
//	end if	
else
	swaigu = dw_ip.object.maip[1]
end if

dw_print.setredraw(false)

//dw_list.object.txt_ymd.text = String(ym, "@@@@년@@월")
//if gubun = "1" then
//	dw_print.setfilter("empno >= '"+ sempno1 +"' and empno <= '"+ sempno2 +"' and gubun LIKE '"+ sgubun +"'")
//	dw_print.filter()	
//	i_rtn = dw_print.Retrieve(gs_sabu, ym, cvcod1, cvcod2, swaigu, ssaupj)
//elseif gubun = "2" then
//	dw_print.setfilter("empno >= '"+ sempno1 +"' and empno <= '"+ sempno2 +"' and gubun LIKE '"+ sgubun +"'")
//	dw_print.filter()		
//   i_rtn = dw_print.Retrieve(gs_sabu, ym, seq)
//elseif gubun = "3" then
//	dw_print.setfilter("empno >= '"+ sempno1 +"' and empno <= '"+ sempno2 +"' and gubun LIKE '"+ sgubun +"'")
//	dw_print.filter()		
//   i_rtn = dw_print.Retrieve(gs_sabu, ym, seq, cvcod1, cvcod2)
//elseif gubun = "4" then
//   i_rtn = dw_print.Retrieve(gs_sabu, ym, cvcod1, cvcod2, swaigu, ssaupj)	
//elseif gubun = "5" then
//   i_rtn = dw_print.Retrieve(gs_sabu, ym, cvcod1, cvcod2, swaigu, ssaupj)		
//end if

if gubun = "1" then
	dw_print.setfilter("empno >= '"+ sempno1 +"' and empno <= '"+ sempno2 +"' and gubun LIKE '"+ sgubun +"'")
	dw_print.filter()	
	i_rtn = dw_print.Retrieve(gs_sabu, ym, cvcod1, cvcod2, swaigu, ssaupj)
elseif gubun = "2" then
//	dw_print.setfilter("empno >= '"+ sempno1 +"' and empno <= '"+ sempno2 +"' and gubun LIKE '"+ sgubun +"'")
//	dw_print.filter()		
   i_rtn = dw_print.Retrieve(gs_sabu, ym, sempno1, sempno2, sgubun, cvcod)
elseif gubun = "3" then
//	dw_print.setfilter("empno >= '"+ sempno1 +"' and empno <= '"+ sempno2 +"' and gubun LIKE '"+ sgubun +"'")
//	dw_print.filter()		
   i_rtn = dw_print.Retrieve(gs_sabu, ym, cvcod1, cvcod2, sempno1, sempno2, sgubun)
end if

dw_print.setredraw(true)

if i_rtn <= 0 then
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
else
	dw_print.ShareData(dw_list)
end if

return 1
end function

on w_imt_04670.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.rr_2
this.Control[iCurrent+4]=this.rr_3
end on

on w_imt_04670.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
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

f_child_saupj(dw_ip, 'empno1', gs_saupj)
f_child_saupj(dw_ip, 'empno2', gs_saupj)

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
dw_print.object.datawindow.print.preview = "yes"	

dw_print.ShareData(dw_list)

PostEvent('ue_open')
end event

event ue_open;call super::ue_open;dw_1.SetTransObject(SQLCA)
dw_1.Reset()
dw_1.InsertRow(0)
dw_ip.SetFocus()

/* 부가 사업장 */
f_mod_saupj(dw_ip,'saupj')
end event

type p_xls from w_standard_print`p_xls within w_imt_04670
end type

type p_sort from w_standard_print`p_sort within w_imt_04670
end type

type p_preview from w_standard_print`p_preview within w_imt_04670
end type

type p_exit from w_standard_print`p_exit within w_imt_04670
end type

type p_print from w_standard_print`p_print within w_imt_04670
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_04670
end type







type st_10 from w_standard_print`st_10 within w_imt_04670
end type



type dw_print from w_standard_print`dw_print within w_imt_04670
integer x = 4032
integer y = 240
string dataobject = "d_imt_04670_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_04670
integer x = 727
integer y = 64
integer width = 3113
integer height = 292
integer taborder = 20
string dataobject = "d_imt_04670_01"
end type

event dw_ip::itemchanged;String  s_cod, s_nam1, s_nam2, snull
Integer i_rtn

setnull(snull)

s_cod = Trim(this.GetText())

if this.GetColumnName() = "ym" then
   if s_cod = '' or isnull(s_cod) then return 	
	if f_datechk(s_cod + '01') = -1 then
		f_message_chk(35, "[기준년월]")
		this.object.ym[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "cvcod" then
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.object.cvcod[1] = s_cod
	this.object.cvnas[1] = s_nam1
	return i_rtn
elseif this.GetColumnName() = "cvcod1" then
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.object.cvcod1[1] = s_cod
	this.object.cvnam1[1] = s_nam1
	return i_rtn
elseif this.GetColumnName() = "cvcod2" then
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.object.cvcod2[1] = s_cod
	this.object.cvnam2[1] = s_nam1
	return i_rtn
elseif getcolumnname() = 'saupj' then
	s_cod = gettext()
	f_child_saupj(dw_ip,'empno1', s_cod)
	f_child_saupj(dw_ip,'empno2', s_cod)
end if
end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;string snull

SetNull(gs_code)
SetNull(gs_codename)
SetNull(sNull)

if this.GetColumnName() = "cvcod1" then
   gs_gubun = '1'
   open(w_vndmst_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.object.cvcod1[1] = gs_code
	this.object.cvnam1[1] = gs_codename
elseif this.GetColumnName() = "cvcod2" then
   gs_gubun = '1'
   open(w_vndmst_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.object.cvcod2[1] = gs_code
	this.object.cvnam2[1] = gs_codename
elseif this.GetColumnName() = "cvcod" then
   gs_gubun = '1'
   open(w_vndmst_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.object.cvcod[1] = gs_code
	this.object.cvnas[1] = gs_codename
//elseIF	this.getcolumnname() = "empno1"	THEN		
//	open(w_sawon_popup)
//	if gs_code = '' or isnull(gs_code) then 	return 
//	this.SetItem(row, "empno1", gs_code)
//	this.SetItem(row, "empnm1", gs_codename)	
//elseIF	this.getcolumnname() = "empno2"	THEN		
//	open(w_sawon_popup)
//	if gs_code = '' or isnull(gs_code) then 	return 
//	this.SetItem(row, "empno2", gs_code)
//	this.SetItem(row, "empnm2", gs_codename)		
elseif this.GetColumnName() = "seq" then	
	gi_page = 0
	gs_code = '2'  // 구매
	
	open(w_imt_05000_1)
	
	setitem(1, "ym", gs_code)
	setitem(1, "seq", gi_page)
	
	setnull(gs_code)
	gi_page = 0	
end if


	
end event

type dw_list from w_standard_print`dw_list within w_imt_04670
integer x = 55
integer y = 420
integer width = 4544
integer height = 1904
string dataobject = "d_imt_04670_02"
boolean border = false
end type

type dw_1 from datawindow within w_imt_04670
integer x = 69
integer y = 44
integer width = 581
integer height = 340
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_imt_04670_00"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String gubun  

gubun = Trim(this.GetText())

dw_ip.SetReDraw(False)
dw_list.SetReDraw(False)
if gubun = "1" then //거래처별
   dw_ip.DataObject = "d_imt_04670_01"
	dw_list.DataObject = "d_imt_04670_02"
	dw_print.DataObject = "d_imt_04670_02_p"
//elseif gubun = "2" then	//마감순번별(요약)
//   dw_ip.DataObject = "d_imt_04670_03"
//	dw_list.DataObject = "d_imt_04670_04"
//	dw_print.DataObject = "d_imt_04670_04_p"
elseif gubun = "2" then	//마감순번별(요약)
   dw_ip.DataObject = "d_imt_04670_03"
	dw_list.DataObject = "d_imt_04670_04-1"
	dw_print.DataObject = "d_imt_04670_04-1_p"	
elseif gubun = "3" then	//마감순번별(상세)
   dw_ip.DataObject = "d_imt_04670_05"
	dw_list.DataObject = "d_imt_04670_06"
	dw_print.DataObject = "d_imt_04670_06_p"
//elseif gubun = "4" then	//원가부서별(요약)
//   dw_ip.DataObject = "d_imt_04670_07"
//	dw_list.DataObject = "d_imt_04670_08"
//	dw_print.DataObject = "d_imt_04670_08_p"
//elseif gubun = "5" then	//원가부서별(상세)
//   dw_ip.DataObject = "d_imt_04670_07"
//	dw_list.DataObject = "d_imt_04670_09"	
//	dw_print.DataObject = "d_imt_04670_09_p"
end if	


If gubun = "1" or gubun = "2"  or gubun = "3"  Then
	//담당자
	f_child_saupj(dw_ip,'empno1',gs_saupj)
	
	//담당자
	f_child_saupj(dw_ip,'empno2',gs_saupj)
End If

dw_ip.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
dw_ip.SetReDraw(True)
dw_print.SetReDraw(True)
dw_ip.SetFocus()

end event

event itemerror;return 1
end event

type rr_1 from roundrectangle within w_imt_04670
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 704
integer y = 36
integer width = 3182
integer height = 356
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_imt_04670
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 408
integer width = 4567
integer height = 1924
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_imt_04670
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 46
integer y = 36
integer width = 640
integer height = 356
integer cornerheight = 40
integer cornerwidth = 55
end type

