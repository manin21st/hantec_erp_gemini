$PBExportHeader$w_imt_04500.srw
$PBExportComments$소급적용현황
forward
global type w_imt_04500 from w_standard_print
end type
type pb_2 from u_pb_cal within w_imt_04500
end type
type pb_1 from u_pb_cal within w_imt_04500
end type
type rr_1 from roundrectangle within w_imt_04500
end type
type rr_2 from roundrectangle within w_imt_04500
end type
end forward

global type w_imt_04500 from w_standard_print
string title = "소급적용 현황"
pb_2 pb_2
pb_1 pb_1
rr_1 rr_1
rr_2 rr_2
end type
global w_imt_04500 w_imt_04500

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string cod1, cod2, scvcod1, scvcod2, sitnbr1, sitnbr2, sempno1, sempno2, swaigu, ssaupj

if dw_ip.AcceptText() = -1 then return -1

cod1 = dw_ip.GetItemString(1, 1)
cod2 = dw_ip.GetItemString(1, 2)
scvcod1 = dw_ip.GetItemString(1, "cvcod1")
scvcod2 = dw_ip.GetItemString(1, "cvcod2")
sitnbr1 = dw_ip.GetItemString(1, "itnbr1")
sitnbr2 = dw_ip.GetItemString(1, "itnbr2")
sempno1 = dw_ip.GetItemString(1, "empno1")
sempno2 = dw_ip.GetItemString(1, "empno2")
ssaupj  = dw_ip.GetItemString(1, "saupj")
swaigu  = dw_ip.GetItemString(1, "maip")

if (IsNull(cod1) or cod1 = "")  then cod1 = "00000000"
if (IsNull(cod2) or cod2 = "")  then cod2 = "99999999"

if (IsNull(scvcod1) or scvcod1 = "")  then scvcod1 = '.'
if (IsNull(scvcod2) or scvcod2 = "")  then scvcod2 = 'ZZZZZZZZ'
if (IsNull(sitnbr1) or sitnbr1 = "")  then sitnbr1 = '.'
if (IsNull(sitnbr2) or sitnbr2 = "")  then sitnbr2 = 'ZZZZZZZZ'
if (IsNull(sempno1) or sempno1 = "")  then sempno1 = '.'
if (IsNull(sempno2) or sempno2 = "")  then sempno2 = 'ZZZZZZZZ'

if dw_list.Retrieve(gs_sabu, cod1, cod2, scvcod1, scvcod2, sitnbr1, sitnbr2, sempno1, sempno2, &
                    swaigu, ssaupj) <= 0 then
	f_message_chk(50,'[소급적용 현황]')
	dw_ip.Setfocus()
	return -1
end if

if dw_print.Retrieve(gs_sabu, cod1, cod2, scvcod1, scvcod2, sitnbr1, sitnbr2, sempno1, sempno2, &
                    swaigu, ssaupj) <= 0 then
	f_message_chk(50,'[소급적용 현황]')
	dw_ip.Setfocus()
	return -1
end if

//dw_print.object.st_date = dw_ip.object.sdate[1]
//dw_print.object.end_date = dw_ip.object.edate[1]
//dw_print.ShareData(dw_list)

cod1 = left(cod1,4) + '/' + mid(cod1,5,2) + '/' + right(cod1,2)
cod2 = left(cod2,4) + '/' + mid(cod2,5,2) + '/' + right(cod2,2)

//dw_list.Object.st_date.text = cod1 + ' - ' + cod2

Return 1


end function

on w_imt_04500.create
int iCurrent
call super::create
this.pb_2=create pb_2
this.pb_1=create pb_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_2
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_imt_04500.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_2)
destroy(this.pb_1)
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

//구매담당자From
f_child_saupj(dw_ip,'empno1', gs_saupj)

//구매담당자To
f_child_saupj(dw_ip,'empno2', gs_saupj)


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

event ue_open;call super::ue_open;//f_mod_saupj(dw_ip,'saupj')
dw_ip.SetItem(1, 1, left(is_today, 6) + '01')
dw_ip.SetItem(1, 2, is_today)
dw_ip.SetFocus()
dw_ip.SetColumn('saupj')

end event

type p_xls from w_standard_print`p_xls within w_imt_04500
end type

type p_sort from w_standard_print`p_sort within w_imt_04500
end type

type p_preview from w_standard_print`p_preview within w_imt_04500
end type

type p_exit from w_standard_print`p_exit within w_imt_04500
end type

type p_print from w_standard_print`p_print within w_imt_04500
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_04500
end type







type st_10 from w_standard_print`st_10 within w_imt_04500
end type



type dw_print from w_standard_print`dw_print within w_imt_04500
string dataobject = "d_imt_04501_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_04500
integer x = 46
integer y = 44
integer width = 3570
integer height = 176
string dataobject = "d_imt_04500"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keyF2!) THEN
   IF	this.getcolumnname() = "cod1"	THEN		
	   gs_code = this.GetText()
	   open(w_itemas_popup2)
	   if isnull(gs_code) or gs_code = "" then 
			this.SetItem(1, "cod1", "")
	      this.SetItem(1, "nam1", "")
	      return
	   else
			this.SetItem(1, "cod1", gs_code)
	      this.SetItem(1, "nam1", gs_codename)
	      this.triggerevent(itemchanged!)
	      return 1
		end if
   ELSEIF this.getcolumnname() = "cod2" THEN		
	   gs_code = this.GetText()
	   open(w_itemas_popup2)
	   if isnull(gs_code) or gs_code = "" then 	
			this.SetItem(1, "cod2", "")
	      this.SetItem(1, "nam2", "")
	      return
	   else
			this.SetItem(1, "cod2", gs_code)
	      this.SetItem(1, "nam2", gs_codename)
	      this.triggerevent(itemchanged!)
	      return 1	
		end if	
   END IF
END IF  
end event

event dw_ip::itemchanged;string	sDate, sNull, scod, snam1, snam2
SetNull(sNull)
integer ireturn

scod = this.gettext()

IF this.GetColumnName() = 'sdate' THEN
	sDate  = this.gettext()
	IF f_datechk(sDate) = -1	then
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
elseIF this.GetColumnName() = 'edate' THEN
	sDate  = this.gettext()
	IF f_datechk(sDate) = -1	then
		this.setitem(1, "edate", sNull)
		return 1
	END IF
elseIF this.GetColumnName() = "cvcod1" THEN
	ireturn = f_get_name2('V0', 'Y', scod, snam1, snam2)
	this.setitem(1, "cvcod1", scod)
	this.setitem(1, "cvnam1", snam1)
	RETURN ireturn
elseIF this.GetColumnName() = "cvcod2" THEN
	ireturn = f_get_name2('V0', 'Y', scod, snam1, snam2)
	this.setitem(1, "cvcod2", scod)
	this.setitem(1, "cvnam2", snam1)
	RETURN ireturn
elseIF this.GetColumnName() = "itnbr1" THEN
	ireturn = f_get_name2('품번', 'Y', scod, snam1, snam2)
	this.setitem(1, "itnbr1", scod)
	this.setitem(1, "itdsc1", snam1)
	RETURN ireturn
elseIF this.GetColumnName() = "itdsc1" THEN
	snam1 = scod
	ireturn = f_get_name2('품명', 'Y', scod, snam1, snam2)
	this.setitem(1, "itnbr1", scod)
	this.setitem(1, "itdsc1", snam1)
	RETURN ireturn
elseIF this.GetColumnName() = "itnbr2" THEN
	ireturn = f_get_name2('품번', 'Y', scod, snam1, snam2)
	this.setitem(1, "itnbr2", scod)
	this.setitem(1, "itdsc2", snam1)
	RETURN ireturn
elseIF this.GetColumnName() = "itdsc2" THEN
	snam1 = scod
	ireturn = f_get_name2('품명', 'Y', scod, snam1, snam2)
	this.setitem(1, "itnbr2", scod)
	this.setitem(1, "itdsc2", snam1)
	RETURN ireturn	
elseif this.getcolumnname() = 'empno1' then
	select rfna1 into :snam1 from reffpf where rfcod = '43' and rfgub = :scod;
	if sqlca.sqlcode <> 0 then
		Messagebox("구매담당자", "구매담당자가 부정확합니다", stopsign!)
		this.setitem(1, "empno1", snull)
		return 1
	end if
elseif this.getcolumnname() = 'empno2' then
	select rfna1 into :snam1 from reffpf where rfcod = '43' and rfgub = :scod;
	if sqlca.sqlcode <> 0 then
		Messagebox("구매담당자", "구매담당자가 부정확합니다", stopsign!)
		this.setitem(1, "empno2", snull)
		return 1
	end if	
elseif GetColumnName() = 'saupj' then
	scod = GetText()
	f_child_saupj(dw_ip,'empno1',scod)
	f_child_saupj(dw_ip,'empno2',scod)
end if
	
end event

event dw_ip::rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

Long Lrow

Lrow = getrow()

if     this.getcolumnname() = 'cvcod1' then
		 open(w_vndmst_popup)
		 setitem(1, "cvcod1", gs_code)
		 setitem(1, "cvnam1", gs_codename)
elseif this.getcolumnname() = 'cvcod2' then	
		 open(w_vndmst_popup)	
		 setitem(1, "cvcod2", gs_code)
		 setitem(1, "cvnam2", gs_codename) 
elseif this.getcolumnname() = 'itnbr1' then
		 gs_gubun = '3'
		 open(w_itemas_popup)	
		 setitem(1, "itnbr1", gs_code)
		 setitem(1, "itdsc1", gs_codename) 	
elseif this.getcolumnname() = 'itnbr2' then	
		 gs_gubun = '3'	
		 open(w_itemas_popup)	
		 setitem(1, "itnbr2", gs_code)
		 setitem(1, "itdsc2", gs_codename) 		
End if

setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)
end event

type dw_list from w_standard_print`dw_list within w_imt_04500
integer x = 46
integer y = 252
integer width = 4553
integer height = 2056
string dataobject = "d_imt_04501"
boolean border = false
end type

type pb_2 from u_pb_cal within w_imt_04500
integer x = 2117
integer y = 40
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('edate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'edate', gs_code)



end event

type pb_1 from u_pb_cal within w_imt_04500
integer x = 1664
integer y = 40
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'sdate', gs_code)



end event

type rr_1 from roundrectangle within w_imt_04500
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 32
integer y = 36
integer width = 3621
integer height = 192
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_imt_04500
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 244
integer width = 4576
integer height = 2080
integer cornerheight = 40
integer cornerwidth = 55
end type

