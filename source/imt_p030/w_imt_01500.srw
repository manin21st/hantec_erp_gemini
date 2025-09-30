$PBExportHeader$w_imt_01500.srw
$PBExportComments$** 년간소요량
forward
global type w_imt_01500 from w_standard_print
end type
type rr_1 from roundrectangle within w_imt_01500
end type
end forward

global type w_imt_01500 from w_standard_print
string title = "년간 소요량"
rr_1 rr_1
end type
global w_imt_01500 w_imt_01500

forward prototypes
public function integer wf_retrieve ()
public function integer wf_retrieve2 ()
public function integer wf_retrieve1 ()
end prototypes

public function integer wf_retrieve ();string sGub
int    i_rtn

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sGub = dw_ip.getitemstring(1, 'gub')

if sGub = '1'  then
	i_rtn = wf_retrieve1()
elseif sGub = '2' then
	i_rtn = wf_retrieve2()
else
	MessageBox("확인","출력구분을 확인 하세요!")
	i_rtn = -1
end if	

return i_rtn

end function

public function integer wf_retrieve2 ();string cyy, pyy, cod1, cod2, itnbr1, itnbr2, sitgu, sittyp, sfitcls, stitcls, sortgu, ssaupj
Integer cha

cyy = trim(dw_ip.object.yyyy[1])
if (IsNull(cyy) or cyy = "")  then 
	f_message_chk(30, "[기준년도]")
	dw_ip.SetColumn("yyyy")
	dw_ip.Setfocus()
	return -1
else
	pyy = Mid(f_aftermonth(cyy + '01', -12),1,4)
end if	

sittyp  = trim(dw_ip.object.ittyp[1])  //품목구분
sfitcls = trim(dw_ip.object.fitcls[1]) //품목분류from
stitcls = trim(dw_ip.object.titcls[1]) //품목분류to
itnbr1 = trim(dw_ip.object.itnbr1[1])
itnbr2 = trim(dw_ip.object.itnbr2[1])
cod1 = trim(dw_ip.object.cvcod1[1])
cod2 = trim(dw_ip.object.cvcod2[1])
ssaupj = trim(dw_ip.object.saupj[1])
sitgu  = trim(dw_ip.object.itgu[1])

if IsNull(cod1) or cod1 = ""  then cod1 = "."
if IsNull(cod2) or cod2 = ""  then cod2 = "ZZZZZZ"
if IsNull(itnbr1) or itnbr1 = ""  then itnbr1 = "."
if IsNull(itnbr2) or itnbr2 = ""  then itnbr2 = "zzzzzzzzzzzzzzz"

if IsNull(sittyp) or sittyp = ""  then sittyp = "%"

if IsNull(sfitcls) or sfitcls = ""  then sfitcls = "."
if IsNull(stitcls) or stitcls = ""  then stitcls = "zzzzzzz"

if IsNull(sitgu)  or sitgu  = ""  then sitgu = "%"

//년간자재소요계획테이블에서 해당년도의 최대계획차수를 산출한다.
 select max(yeacha) 
  into :cha
  from yeapln_meip
 where sabu = :gs_sabu and yeayymm like :cyy||'%';

if isnull(cha) or cha < 1 then cha = 1


dw_list.DataObject = "d_imt_01500_04"
dw_print.DataObject = "d_imt_01500_04_p"
dw_print.SetTransObject(SQLCA)

sortgu = dw_ip.getitemstring(1, 'sortgu')
if sortgu = '1' then //품번순
	dw_print.setsort("ittyp A, itcls A, itnbr A")
else
	dw_print.setsort("ittyp A, itcls A, itdsc A, ispec A")
end if
dw_print.sort()
dw_print.GroupCalc()

dw_print.object.txt_title.text = cyy + "년 소요량"
if dw_print.Retrieve(gs_sabu, cyy, cha, pyy, cod1, cod2, sittyp, sfitcls, stitcls, &
                    itnbr1, itnbr2, sitgu, ssaupj ) <= 0 then
	f_message_chk(50,'[년간 소요량]')
	dw_ip.Setfocus()
	return -1
else
	dw_print.sharedata(dw_list)
end if

return 1
end function

public function integer wf_retrieve1 ();string cyy, pyy, cod1, cod2, itnbr1, itnbr2, sempno, sitgu, sittyp, sfitcls, stitcls, sortgu, ssaupj
Integer cha

cyy = trim(dw_ip.object.yyyy[1])
if (IsNull(cyy) or cyy = "")  then 
	f_message_chk(30, "[기준년도]")
	dw_ip.SetColumn("yyyy")
	dw_ip.Setfocus()
	return -1
else
	pyy = Mid(f_aftermonth(cyy + '01', -12),1,4)
end if	

sittyp  = trim(dw_ip.object.ittyp[1])  //품목구분
sfitcls = trim(dw_ip.object.fitcls[1]) //품목분류from
stitcls = trim(dw_ip.object.titcls[1]) //품목분류to
itnbr1 = trim(dw_ip.object.itnbr1[1])
itnbr2 = trim(dw_ip.object.itnbr2[1])
cod1 = trim(dw_ip.object.cvcod1[1])
cod2 = trim(dw_ip.object.cvcod2[1])
ssaupj = trim(dw_ip.object.saupj[1])
sempno = trim(dw_ip.object.empno[1])
sitgu  = trim(dw_ip.object.itgu[1])

if IsNull(cod1) or cod1 = ""  then cod1 = "."
if IsNull(cod2) or cod2 = ""  then cod2 = "ZZZZZZ"
if IsNull(itnbr1) or itnbr1 = ""  then itnbr1 = "."
if IsNull(itnbr2) or itnbr2 = ""  then itnbr2 = "zzzzzzzzzzzzzzz"

if IsNull(sittyp) or sittyp = ""  then sittyp = "%"

if IsNull(sfitcls) or sfitcls = ""  then sfitcls = "."
if IsNull(stitcls) or stitcls = ""  then stitcls = "zzzzzzz"

if IsNull(sitgu)  or sitgu  = ""  then sitgu = "%"
if IsNull(sempno) or sempno = ""  then sempno = "%"

//년간자재소요계획테이블에서 해당년도의 최대계획차수를 산출한다.
 select max(yeacha) 
  into :cha
  from yeapln_meip
 where sabu = :gs_sabu and yeayymm like :cyy||'%';
 
if isnull(cha) or cha < 1 then cha = 1

dw_list.DataObject = "d_imt_01500_03"
dw_print.DataObject = "d_imt_01500_03_p"
dw_print.SetTransObject(SQLCA)

sortgu = dw_ip.getitemstring(1, 'sortgu')
if sortgu = '1' then //품번순
	dw_print.setsort("mtrvnd A, itnbr A")
else
	dw_print.setsort("mtrvnd A, itdsc A, ispec A")
end if
dw_print.sort()
dw_print.GroupCalc()

dw_print.object.txt_title.text = cyy + "년 소요량"

if dw_print.Retrieve(gs_sabu, cyy, cha, pyy, cod1, cod2, sittyp, sfitcls, stitcls, &
                    itnbr1, itnbr2, sempno, sitgu, ssaupj ) <= 0 then
	f_message_chk(50,'[년간 소요량]')
	dw_ip.Setfocus()
	return -1
else
	dw_print.sharedata(dw_list)
end if

return 1
end function

on w_imt_01500.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_imt_01500.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
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

f_child_saupj(dw_ip,'empno',gs_saupj)

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

dw_ip.setitem(1, 'yyyy', left(is_today, 4))

/* 부가 사업장 */
f_mod_saupj(dw_ip,'saupj')



end event

type p_preview from w_standard_print`p_preview within w_imt_01500
end type

type p_exit from w_standard_print`p_exit within w_imt_01500
end type

type p_print from w_standard_print`p_print within w_imt_01500
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_01500
end type







type st_10 from w_standard_print`st_10 within w_imt_01500
end type



type dw_print from w_standard_print`dw_print within w_imt_01500
string dataobject = "d_imt_01500_03_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_01500
integer x = 0
integer y = 0
integer width = 3163
integer height = 464
string dataobject = "d_imt_01500_01"
end type

event dw_ip::itemchanged;string  s_cod, s_nam1, s_nam2
Integer i_rtn

if this.getcolumnname() = 'itnbr1' then 
	s_cod = Trim(this.GetText())
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr1[1] = s_cod
	this.object.itdsc1[1] = s_nam1
	return i_rtn
elseif this.getcolumnname() = 'itdsc1' then 
	s_nam1 = Trim(this.GetText())
	i_rtn = f_get_name2("품명", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr1[1] = s_cod
	this.object.itdsc1[1] = s_nam1
	return i_rtn
elseif this.getcolumnname() = 'itnbr2' then 
	s_cod = Trim(this.GetText())
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr2[1] = s_cod
	this.object.itdsc2[1] = s_nam1
	return i_rtn
elseif this.getcolumnname() = 'itdsc2' then 
	s_nam1 = Trim(this.GetText())
	i_rtn = f_get_name2("품명", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr2[1] = s_cod
	this.object.itdsc2[1] = s_nam1
	return i_rtn
elseif getcolumnname() = 'saupj' then
	s_cod = gettext()
	
	f_child_saupj(dw_ip,'empno',s_cod)
end if

end event

event dw_ip::rbuttondown;string sittyp
str_itnct lstr_sitnct


SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

IF this.getcolumnname() = "cvcod1"	THEN //거래처코드(FROM)		
   gs_gubun = '1'
	open(w_vndmst_popup)
	if isnull(gs_code) or gs_code = '' then return 
   this.SetItem(1, "cvcod1", gs_code)
ELSEIF this.getcolumnname() = "cvcod2"	THEN //거래처코드(TO)		
   gs_gubun = '1'
	open(w_vndmst_popup)
	if isnull(gs_code) or gs_code = '' then return 
   this.SetItem(1, "cvcod2", gs_code)
ELSEIF this.getcolumnname() = "itnbr1"	THEN 
   gs_gubun = '3'
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = '' then return 
   this.SetItem(1, "itnbr1", gs_code)
	this.SetItem(1, "itdsc1", gs_codename)
ELSEIF this.getcolumnname() = "itnbr2"	THEN 
   gs_gubun = '3'
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = '' then return 
   this.SetItem(1, "itnbr2", gs_code)
	this.SetItem(1, "itdsc2", gs_codename)
ELSEIF this.GetColumnName() = 'fitcls' then

	this.accepttext()
	sIttyp = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp", lstr_sitnct.s_ittyp)
	this.SetItem(1,"fitcls", lstr_sitnct.s_sumgub)
ELSEIF this.GetColumnName() = 'titcls' then
	this.accepttext()
	sIttyp = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp", lstr_sitnct.s_ittyp)
	this.SetItem(1,"titcls", lstr_sitnct.s_sumgub)
END IF
end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_imt_01500
integer x = 18
integer y = 472
integer height = 1860
string dataobject = "d_imt_01500_03"
boolean border = false
end type

type rr_1 from roundrectangle within w_imt_01500
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 5
integer y = 464
integer width = 4626
integer height = 1884
integer cornerheight = 40
integer cornerwidth = 55
end type

