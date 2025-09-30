$PBExportHeader$w_sal_07050.srw
$PBExportComments$일일 입고금액 현황(출력)
forward
global type w_sal_07050 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_07050
end type
end forward

global type w_sal_07050 from w_standard_print
integer height = 2424
string title = "일일 사급 현황"
rr_1 rr_1
end type
global w_sal_07050 w_sal_07050

type variables

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string   s_stdym, scvcod1, scvcod2, sitnbr1, sitnbr2, sempno1, sempno2, sitgu1, sitgu2, swaigu, s_saupj
string   sittyp

IF dw_ip.AcceptText() = -1 THEN RETURN -1

s_saupj  = TRIM(dw_ip.GetItemString(1,"saupj"))
s_stdym  = TRIM(dw_ip.GetItemString(1,"stdym"))
scvcod1  = TRIM(dw_ip.GetItemString(1,"cvcod1"))
scvcod2  = TRIM(dw_ip.GetItemString(1,"cvcod2"))
sitnbr1  = TRIM(dw_ip.GetItemString(1,"itnbr1"))
sitnbr2  = TRIM(dw_ip.GetItemString(1,"itnbr2"))
sempno1  = TRIM(dw_ip.GetItemString(1,"empno1"))
sempno2  = TRIM(dw_ip.GetItemString(1,"empno2"))
sitgu1   = TRIM(dw_ip.GetItemString(1,"itgu1"))
sitgu2   = TRIM(dw_ip.GetItemString(1,"itgu2"))
swaigu   = TRIM(dw_ip.GetItemString(1,"maip"))
sittyp   = TRIM(dw_ip.GetItemString(1,"ittyp"))

if isnull(scvcod1) or scvcod1 = '' then scvcod1 = '.'
if isnull(scvcod2) or scvcod2 = '' then scvcod2 = 'zzzzzz'
if isnull(sitnbr1) or sitnbr1 = '' then sitnbr1 = '.'
if isnull(sitnbr2) or sitnbr2 = '' then sitnbr2 = 'zzzzzzzzzzzzzzz'
if isnull(sempno1) or sempno1 = '' then sempno1 = '.'
if isnull(sempno2) or sempno2 = '' then sempno2 = 'zzzzzz'
if isnull(sittyp)  or sittyp  = '' then sittyp = '%'

IF (IsNull(s_stdym) OR s_stdym = "") THEN
   f_message_chk(30, "[기준년월]")
	dw_ip.SetColumn('stdym')
	dw_ip.SetFocus()
	return -1
END IF

IF (IsNull(s_saupj) or s_saupj = "" ) then
	f_message_chk(30, "[사업장]")
   dw_ip.SetColumn( 'saupj')
	dw_ip.SetFocus()
	return -1
end if
//dw_list.setredraw(false)
IF dw_print.Retrieve(gs_sabu, s_stdym, scvcod1, scvcod2, sitnbr1, sitnbr2, &
                    sitgu1, sitgu2, swaigu, s_saupj, sittyp ) < 1 THEN
	f_message_chk(50,"[일일 사급 현황]")
//	dw_list.setredraw(true) 
	dw_ip.SetColumn('stdym')
	dw_ip.SetFocus()
	return -1
ELSE
	dw_print.ShareData(dw_list)
END IF

//dw_list.setredraw(true)

Return 1
end function

on w_sal_07050.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_07050.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;string  s_stdym

s_stdym = Mid(f_today(),1,6)

//초기화
dw_ip.SetItem(1, "stdym", s_stdym)		


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

f_child_saupj(dw_ip,'empno1',gs_saupj)
f_child_saupj(dw_ip,'empno2',gs_saupj)

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

f_mod_saupj(dw_ip,'saupj')

PostEvent('ue_open')
end event

type p_preview from w_standard_print`p_preview within w_sal_07050
end type

type p_exit from w_standard_print`p_exit within w_sal_07050
end type

type p_print from w_standard_print`p_print within w_sal_07050
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_07050
end type







type st_10 from w_standard_print`st_10 within w_sal_07050
end type



type dw_print from w_standard_print`dw_print within w_sal_07050
integer x = 3968
integer y = 168
string dataobject = "d_sal_07050_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_07050
integer x = 14
integer y = 20
integer width = 3909
integer height = 276
string dataobject = "d_sal_07050_1"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

if     this.getcolumnname() = 'cvcod1' then
		 open(w_vndmst_popup)
		 if gs_code = '' or isnull(gs_code) then return 
		 setitem(1, "cvcod1", gs_code)
		 setitem(1, "cvnam1", gs_codename)
elseif this.getcolumnname() = 'cvcod2' then	
		 open(w_vndmst_popup)	
		 if gs_code = '' or isnull(gs_code) then return 
		 setitem(1, "cvcod2", gs_code)
		 setitem(1, "cvnam2", gs_codename) 
elseif this.getcolumnname() = 'itnbr1' then
		 gs_gubun = '3'
		 open(w_itemas_popup)	
		 if gs_code = '' or isnull(gs_code) then return 
		 setitem(1, "itnbr1", gs_code)
		 setitem(1, "itdsc1", gs_codename) 	
elseif this.getcolumnname() = 'itnbr2' then	
		 gs_gubun = '3'	
		 open(w_itemas_popup)	
		 if gs_code = '' or isnull(gs_code) then return 
		 setitem(1, "itnbr2", gs_code)
		 setitem(1, "itdsc2", gs_codename) 		
End if


end event

event dw_ip::itemchanged;string scod, snam1, snam2, snull
integer ireturn

setnull(sNull)

scod = this.gettext()

if this.getcolumnname() = 'gijun' then
	if scod = '1' then
		dw_list.dataobject = 'd_imt_04601'
	else
		dw_list.dataobject = 'd_imt_04611'
	end if
	dw_list.settransobject(sqlca)
	p_print.Enabled =False
   p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

	p_preview.enabled = False
	p_preview.PictureName =  'C:\erpman\image\미리보기_d.gif'
	
elseif this.getcolumnname() = 'stdym' then
	IF scod = '' or isnull(scod) then 
		setitem(1, "stdym", left(f_today(), 6))
		return
	end if
	IF f_datechk(scod+'01') = -1	then
		this.setitem(1, "stdym", left(f_today(), 6))
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
elseif getcolumnname() = 'saupj' then
	f_child_saupj(dw_ip,'empno1',scod)
	f_child_saupj(dw_ip,'empno2',scod)
end if
	
end event

type dw_list from w_standard_print`dw_list within w_sal_07050
integer x = 32
integer width = 4581
string dataobject = "d_sal_07050_2"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_07050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 296
integer width = 4599
integer height = 2024
integer cornerheight = 40
integer cornerwidth = 55
end type

