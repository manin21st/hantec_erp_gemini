$PBExportHeader$w_pya2010.srw
$PBExportComments$해외출장등록
forward
global type w_pya2010 from w_inherite_standard
end type
type dw_ip from datawindow within w_pya2010
end type
type dw_1 from datawindow within w_pya2010
end type
type dw_list from u_d_popup_sort within w_pya2010
end type
type rr_1 from roundrectangle within w_pya2010
end type
end forward

global type w_pya2010 from w_inherite_standard
string title = "해외 출장 등록"
dw_ip dw_ip
dw_1 dw_1
dw_list dw_list
rr_1 rr_1
end type
global w_pya2010 w_pya2010

type variables
boolean b_flag
//string smodstatus
end variables

forward prototypes
public function integer wf_insert_chuljang ()
public function integer wf_requiredchk (integer icurrow)
public subroutine wf_setting_retrievemode (string mode)
end prototypes

public function integer wf_insert_chuljang ();string sempno, smokjuk, scountry, sarea, sdate, tdate,sgubun,ename,srateday
double air, ilbi, bedcost, gita, sair, silbi, sbedcost, sgita, samt, samt2, samt3,srate,srateamt
int cnt

sempno = dw_1.getitemstring(1,"p1_master_empno")
ename = dw_1.getitemstring(1,"p1_master_empnameeng")
smokjuk = dw_1.getitemstring(1,"mokjuk")
scountry = dw_1.getitemstring(1,"country")
sarea = dw_1.getitemstring(1,"area")
sdate = dw_1.getitemstring(1,"frdate")
tdate = dw_1.getitemstring(1,"todate")
sgubun = dw_1.getitemstring(1,"gubun")
air =  dw_1.getitemNumber(1,"aircost")
ilbi = dw_1.getitemNumber(1,"ilbi")
bedcost = dw_1.getitemNumber(1,"bedcost")
gita = dw_1.getitemNumber(1,"gita")
sair =  dw_1.getitemNumber(1,"saircost")
silbi = dw_1.getitemNumber(1,"silbi")
sbedcost = dw_1.getitemNumber(1,"sbedcost")
sgita = dw_1.getitemNumber(1,"sgita")
samt = dw_1.getitemNumber(1,"compute_1")
samt2 = dw_1.getitemNumber(1,"compute_2")
samt3 = dw_1.getitemNumber(1,"compute_3")
srateday = dw_1.getitemstring(1,"p1_chuljang_yratedate")
srate = dw_1.getitemNumber(1,"p1_chuljang_yrate")
srateamt = dw_1.GetitemNumber(1,"p1_chuljang_yrateamt")

select count(*) into :cnt
from p1_chuljang
where empno = :sempno and
      frdate = :sdate ;
if cnt > 0 then
	
	UPDATE "P1_CHULJANG"
	SET "EMPNO" = :sempno,              "E_NAME" = :ename,             "COUNTRY" = :scountry,    
	    "AREA" =  :sarea,             "FRDATE" = :sdate,               "TODATE" = :tdate,  
		 "GUBUN" = :sgubun,              "MOKJUK" = :smokjuk,           "AIRCOST" = :air,   
		 "ILBI" = :ilbi,              "BEDCOST" = :bedcost,              "GITA" = :gita,    
		 "BIYONG" =  :air + :ilbi + :bedcost + :gita,
		 "SAIRCOST" = :sair,   
		 "SILBI" = :silbi,              "SBEDCOST" = :sbedcost,              "SGITA" = :sgita,    
		 "SBIYUNG" = :sair + :silbi + :sbedcost + :sgita,
		 "YRATE" = :srate,             "YRATEDATE" = :srateday,        "YRATEAMT" = :srateamt
  WHERE EMPNO = :sempno and
        FRDATE = :sdate;
	
else
  INSERT INTO "P1_CHULJANG"  
         ( "EMPNO",              "E_NAME",             "COUNTRY",                 "AREA",            "FRDATE",   
           "TODATE",              "GUBUN",              "MOKJUK",              "AIRCOST",              "ILBI",   
           "BEDCOST",              "GITA",              "BIYONG",             "SAIRCOST",             "SILBI",   
           "SBEDCOST",            "SGITA",              "GONGJE",              "SBIYUNG",             "DESCR",   
           "CURR",                "YRATE",                "YAMT",             "GJG_SAUPJ",       "GJG_BALDATE",   
           "GJG_UPMUGU",     "GJG_BJUNNO",           "GJG_LINNO",              "JS_SAUPJ",   
           "JS_BALDATE",      "JS_UPMUGU",           "JS_BJUNNO",              "JS_LINNO", 
			  "YRATEDATE",        "YRATEAMT")  
  VALUES ( :sempno,                :ename,             :scountry,                  :sarea,              :sdate,   
           :tdate,                :sgubun,              :smokjuk,                    :air,               :ilbi,   
           :bedcost,                :gita,                 :samt,                   :sair,              :silbi,
	        :sbedcost,              :sgita,                :samt3,                  :samt2,                null,              
           null,                   :srate,                   null,                   null,                null,
			  null,                     null,                   null,                   null,                
			  null,                     null,                   null,                   null, 
			  :srateday,           :srateamt)  ;
end if			  
			  
if sqlca.sqlcode <> 0 then
	return -1
else
   return 1
end if
end function

public function integer wf_requiredchk (integer icurrow);string s_empno, s_mokjuk, s_country, s_frdate, s_todate, s_area, s_gubun

if dw_1.accepttext() = -1 then return -1

s_empno = dw_1.getitemstring(dw_1.getrow(), "p1_master_empno")
s_mokjuk = dw_1.getitemstring(dw_1.getrow(), "mokjuk")
s_country = dw_1.getitemstring(dw_1.getrow(), "country")
s_frdate = dw_1.getitemstring(dw_1.getrow(), "frdate")
s_todate = dw_1.getitemstring(dw_1.getrow(), "todate")
s_area = dw_1.getitemstring(dw_1.getrow(), "area")
s_gubun = dw_1.getitemstring(dw_1.getrow(), "gubun")

if s_empno = "" or isnull(s_empno) then
	f_messagechk(1, "[사번]")
	dw_1.setcolumn("p1_master_empno")
	dw_1.setfocus()
	return -1 
end if

if s_mokjuk = "" or isnull(s_mokjuk) then
	f_messagechk(1, "[출장목적]")
	dw_1.setcolumn("mokjuk")
	dw_1.setfocus()
	return -1 
end if

if s_country = "" or isnull(s_country) then
	f_messagechk(1, "[출장국]")
	dw_1.setcolumn("country")
	dw_1.setfocus()
	return -1 
end if

if s_frdate = "" or isnull(s_frdate) then
	f_messagechk(1, "[출장시작일]")
	dw_1.setcolumn("frdate")
	dw_1.setfocus()
	return -1 
end if

if s_todate = "" or isnull(s_todate) then
	f_messagechk(1, "[출장종료일]")
	dw_1.setcolumn("todate")
	dw_1.setfocus()
	return -1 
end if

if s_area = "" or isnull(s_area) then
	f_messagechk(1, "[출장지]")
	dw_1.setcolumn("area")
	dw_1.setfocus()
	return -1 
end if

if s_gubun = "" or isnull(s_gubun) then
	f_messagechk(1, "[출장구분]")
	dw_1.setcolumn("gubun")
	dw_1.setfocus()
	return -1 
end if

return 1


end function

public subroutine wf_setting_retrievemode (string mode);//dw_1.SetRedraw(False)
//IF mode ="M" THEN
//	dw_1.SetTabOrder("ab_dpno",0)
//	dw_1.SetColumn("ab_name")
//	
//	cb_del.Enabled =True
//ELSE
//	dw_1.SetTabOrder("ab_dpno",10)
//	dw_1.SetColumn("ab_dpno")
//	cb_del.Enabled =False
//END IF
//dw_1.SetFocus()
//dw_1.SetRedraw(True)
end subroutine

on w_pya2010.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
this.dw_1=create dw_1
this.dw_list=create dw_list
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.dw_list
this.Control[iCurrent+4]=this.rr_1
end on

on w_pya2010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ip)
destroy(this.dw_1)
destroy(this.dw_list)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_1.settransobject(sqlca)

dw_ip.insertrow(0)
dw_ip.setcolumn("p0_dept_deptcode")
dw_ip.setfocus()
dw_1.insertrow(0)

end event

type p_mod from w_inherite_standard`p_mod within w_pya2010
integer x = 3895
end type

event p_mod::clicked;call super::clicked;integer iFunctionValue, icurrow
string  s_empno

icurrow = dw_1.GetRow()

  IF dw_1.AcceptText() = -1 THEN Return

  IF dw_list.RowCount() > 0 THEN
	  iFunctionValue = wf_requiredChk(icurrow)
	  IF iFunctionValue <> 1 THEN RETURN
  ELSE
  	iFunctionValue = 1	
  END IF

  IF iFunctionValue = 1 THEN
     IF messagebox("확인", "저장하시겠습니까?", question!, yesno!) = 2 then return 
	
      IF wf_insert_chuljang() = 1 THEN
	      commit;
			dw_ip.reset()
			dw_ip.insertrow(0)
			p_inq.Triggerevent(Clicked!)
			dw_1.reset()
			dw_1.insertrow(0)
			dw_1.setcolumn("p1_master_empno")
			dw_1.setfocus()
	      w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"
		ELSE
			ROLLBACK;
			w_mdi_frame.sle_msg.text ="자료 저장 실패.!!!"
      END IF

         dw_1.SetReDraw(True) 

END IF

end event

type p_del from w_inherite_standard`p_del within w_pya2010
integer x = 4069
end type

event p_del::clicked;call super::clicked;string s_empno, s_delno, s_gjgjpno, s_jsjpno, sdate

if dw_1.accepttext() = -1 then return
 
IF dw_1.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return 
END IF

s_gjgjpno = dw_1.getitemstring(dw_1.getrow(), "gjgjpno")
s_jsjpno = dw_1.getitemstring(dw_1.getrow(), "jsjpno")

if (s_gjgjpno = "" or isnull(s_gjgjpno))  and (s_jsjpno = "" or isnull(s_jsjpno)) then

	IF MessageBox("확인", "삭제하시겠습니까?", question!, yesno!) = 2	THEN	RETURN
	
	s_delno = dw_1.GetItemString(dw_1.GetRow(),"p1_master_empno")
	sdate   = dw_1.getitemstring(1,"frdate")
	
		DELETE FROM p1_chuljang WHERE empno = :s_delno and frdate = :sdate ;
		commit ;
		
		w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"
		dw_ip.reset()
		dw_ip.insertrow(0)
	   dw_1.reset()
		dw_1.insertrow(0)
		dw_1.setcolumn("p1_master_empno")
		dw_1.setfocus()
		p_inq.Triggerevent(Clicked!)
	

end if

end event

type p_inq from w_inherite_standard`p_inq within w_pya2010
integer x = 3547
end type

event p_inq::clicked;call super::clicked;string s_deptcode, s_deptname, s_gradecode, s_empno, s_empname, s_frdate

if dw_ip.accepttext() = -1 then return

s_deptcode = dw_ip.getitemstring(1, "p0_dept_deptcode")
s_gradecode = dw_ip.getitemstring(1, "p1_master_gradecode")
s_empno = dw_ip.getitemstring(1,"p1_master_empno")	
s_frdate = dw_ip.getitemstring(dw_ip.getrow(), "p1_chuljang_frdate")

if	IsNull(s_deptcode) or s_deptcode = '' then s_deptcode = '%'
if	IsNull(s_gradecode) or s_gradecode = '' then s_gradecode = '%'
if IsNull(s_empno) or s_empno = '' then s_empno = '%'
if	IsNull(s_frdate) or s_frdate = '' then s_frdate = '19000101'

if dw_list.retrieve(s_empno, s_gradecode, s_deptcode, s_frdate) > 0 then
	dw_list.selectrow(0, false)
	dw_list.selectrow(1, true)	
	dw_list.scrolltorow(1)
end if


end event

type p_print from w_inherite_standard`p_print within w_pya2010
boolean visible = false
integer x = 2761
integer y = 2496
end type

type p_can from w_inherite_standard`p_can within w_pya2010
integer x = 4242
end type

event p_can::clicked;call super::clicked;dw_ip.reset()
dw_ip.insertrow(0)
dw_ip.setfocus()

dw_list.Reset()
dw_list.SelectRow(0,False)
dw_list.SelectRow(1,True)


dw_1.Reset()
dw_1.insertrow(0)
end event

type p_exit from w_inherite_standard`p_exit within w_pya2010
integer x = 4416
end type

type p_ins from w_inherite_standard`p_ins within w_pya2010
integer x = 3721
end type

event p_ins::clicked;call super::clicked;  dw_1.reset()
  dw_1.insertrow(0)
  dw_1.setcolumn("p1_master_empno")
  dw_1.setfocus()
end event

type p_search from w_inherite_standard`p_search within w_pya2010
boolean visible = false
integer x = 2587
integer y = 2496
end type

type p_addrow from w_inherite_standard`p_addrow within w_pya2010
boolean visible = false
integer x = 2935
integer y = 2496
end type

type p_delrow from w_inherite_standard`p_delrow within w_pya2010
boolean visible = false
integer x = 3109
integer y = 2496
end type

type dw_insert from w_inherite_standard`dw_insert within w_pya2010
boolean visible = false
integer x = 64
integer y = 2280
end type

type st_window from w_inherite_standard`st_window within w_pya2010
boolean visible = false
end type

type cb_exit from w_inherite_standard`cb_exit within w_pya2010
boolean visible = false
integer x = 2103
integer y = 2580
end type

type cb_update from w_inherite_standard`cb_update within w_pya2010
boolean visible = false
integer x = 1001
integer y = 2580
end type

event cb_update::clicked;call super::clicked;integer iFunctionValue, icurrow
string  s_empno

icurrow = dw_1.GetRow()

  IF dw_1.AcceptText() = -1 THEN Return

  IF dw_list.RowCount() > 0 THEN
	  iFunctionValue = wf_requiredChk(icurrow)
	  IF iFunctionValue <> 1 THEN RETURN
  ELSE
  	iFunctionValue = 1	
  END IF

  IF iFunctionValue = 1 THEN
     IF messagebox("확인", "저장하시겠습니까?", question!, yesno!) = 2 then return 
	
      IF wf_insert_chuljang() = 1 THEN
	      commit;
			dw_ip.reset()
			dw_ip.insertrow(0)
			cb_retrieve.Triggerevent(Clicked!)
			dw_1.reset()
			dw_1.insertrow(0)
			dw_1.setcolumn("p1_master_empno")
			dw_1.setfocus()
	      sle_msg.text ="자료가 저장되었습니다.!!!"
		ELSE
			ROLLBACK;
			sle_msg.text ="자료 저장 실패.!!!"
      END IF

         dw_1.SetReDraw(True) 

END IF

end event

type cb_insert from w_inherite_standard`cb_insert within w_pya2010
boolean visible = false
integer x = 562
integer y = 2580
string text = "추가(&I)"
end type

event cb_insert::clicked;call super::clicked;
  dw_1.reset()
  dw_1.insertrow(0)
  dw_1.setcolumn("p1_master_empno")
  dw_1.setfocus()
  
  
end event

type cb_delete from w_inherite_standard`cb_delete within w_pya2010
boolean visible = false
integer x = 1367
integer y = 2580
end type

event cb_delete::clicked;call super::clicked;string s_empno, s_delno, s_gjgjpno, s_jsjpno, sdate

if dw_1.accepttext() = -1 then return
 
IF dw_1.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return 
END IF

s_gjgjpno = dw_1.getitemstring(dw_1.getrow(), "gjgjpno")
s_jsjpno = dw_1.getitemstring(dw_1.getrow(), "jsjpno")

if (s_gjgjpno = "" or isnull(s_gjgjpno))  and (s_jsjpno = "" or isnull(s_jsjpno)) then

	IF MessageBox("확인", "삭제하시겠습니까?", question!, yesno!) = 2	THEN	RETURN
	
	s_delno = dw_1.GetItemString(dw_1.GetRow(),"p1_master_empno")
	sdate   = dw_1.getitemstring(1,"frdate")
	
		DELETE FROM p1_chuljang WHERE empno = :s_delno and frdate = :sdate ;
		commit ;
		
		sle_msg.text ="자료가 삭제되었습니다.!!!"
		dw_ip.reset()
		dw_ip.insertrow(0)
	   dw_1.reset()
		dw_1.insertrow(0)
		dw_1.setcolumn("p1_master_empno")
		dw_1.setfocus()
		cb_retrieve.Triggerevent(Clicked!)
	

end if

end event

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pya2010
boolean visible = false
integer x = 197
integer y = 2580
end type

event cb_retrieve::clicked;call super::clicked;string s_deptcode, s_deptname, s_gradecode, s_empno, s_empname, s_frdate

if dw_ip.accepttext() = -1 then return

s_deptcode = dw_ip.getitemstring(1, "p0_dept_deptcode")
s_gradecode = dw_ip.getitemstring(1, "p1_master_gradecode")
s_empno = dw_ip.getitemstring(1,"p1_master_empno")	
s_frdate = dw_ip.getitemstring(dw_ip.getrow(), "p1_chuljang_frdate")

if	IsNull(s_deptcode) or s_deptcode = '' then s_deptcode = '%'
if	IsNull(s_gradecode) or s_gradecode = '' then s_gradecode = '%'
if IsNull(s_empno) or s_empno = '' then s_empno = '%'
if	IsNull(s_frdate) or s_frdate = '' then s_frdate = '19000101'

if dw_list.retrieve(s_empno, s_gradecode, s_deptcode, s_frdate) > 0 then
	dw_list.selectrow(0, false)
	dw_list.selectrow(1, true)	
	dw_list.scrolltorow(1)
end if


end event

type st_1 from w_inherite_standard`st_1 within w_pya2010
boolean visible = false
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pya2010
boolean visible = false
integer x = 1733
integer y = 2580
end type

event cb_cancel::clicked;call super::clicked;sle_msg.text =""


dw_ip.reset()
dw_ip.insertrow(0)
dw_ip.setfocus()

dw_list.Reset()
dw_list.SelectRow(0,False)
dw_list.SelectRow(1,True)


dw_1.Reset()
dw_1.insertrow(0)




end event

type dw_datetime from w_inherite_standard`dw_datetime within w_pya2010
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_pya2010
boolean visible = false
end type

type gb_2 from w_inherite_standard`gb_2 within w_pya2010
boolean visible = false
integer x = 960
integer y = 2520
end type

type gb_1 from w_inherite_standard`gb_1 within w_pya2010
boolean visible = false
integer x = 160
integer y = 2520
end type

type gb_10 from w_inherite_standard`gb_10 within w_pya2010
boolean visible = false
end type

type dw_ip from datawindow within w_pya2010
event ue_key pbm_dwnkey
event ue_enter pbm_dwnprocessenter
integer x = 343
integer y = 68
integer width = 2208
integer height = 284
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_pya2010"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_enter;send(handle(this), 256, 9, 0)

return 1
end event

event rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)

if this.AcceptText() = -1 then return

IF this.getcolumnname() = "p0_dept_deptcode" THEN
	Gs_Code = this.GetText()
	
	Open(w_dept_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(), "p0_dept_deptcode", Gs_code)
	this.SetItem(this.GetRow(), "p0_dept_deptname", Gs_codename)
//	this.TriggerEvent(ItemChanged!)
END IF

IF this.getcolumnname() = "p1_master_empno" THEN
	Gs_Code = this.GetText()
	
	open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(), "p1_master_empno", Gs_code)
   this.SetItem(this.GetRow(), "p1_master_empname", Gs_codename)
//	this.TriggerEvent(ItemChanged!)
END IF

end event

event itemchanged;string s_deptcode, s_deptname, s_gradecode, s_empno, s_empname, s_frdate, snull

setnull(snull)

if this.getcolumnname() = "p0_dept_deptcode" then
	s_deptcode = this.gettext()
	
	if s_deptcode = "" or isnull(s_deptcode) then
		dw_ip.setitem(dw_ip.getrow(), "p0_dept_deptcode", snull)
		dw_ip.setitem(dw_ip.getrow(), "p0_dept_deptname", snull)
	else
	   SELECT "P0_DEPT"."DEPTCODE" 
	     INTO :s_deptname
	     FROM "P0_DEPT"
	    WHERE "P0_DEPT"."DEPTCODE" like :s_deptcode ;
	 
	    if sqlca.sqlcode <> 0 then
		    messagebox("확인", "부서코드를 확인하세요.")
			 dw_ip.setitem(dw_ip.getrow(), "p0_dept_deptcode", snull)
			 dw_ip.setitem(dw_ip.getrow(), "p0_dept_deptname", snull)
			 dw_ip.setcolumn("p0_dept_deptcode")
			 dw_ip.setfocus()
			 return
		else
			dw_ip.setitem(dw_ip.getrow(),"p0_dept_deptname", s_deptname)
		end if
	end if
	
elseif this.getcolumnname() = "p1_master_empno" then 
   s_empno = this.gettext()
	
	if s_empno = "" or isnull(s_empno) then
		dw_ip.setitem(dw_ip.getrow(), "p1_master_empno", snull)
		dw_ip.setitem(dw_ip.getrow(), "p1_master_empname", snull)
	else
		SELECT "P1_MASTER"."EMPNAME"
		  INTO :s_empname
		  FROM "P1_MASTER"
		 WHERE "P1_MASTER"."EMPNO" like :s_empno ;
		 
		 if sqlca.sqlcode <> 0 then
			messagebox("확인", "사원번호를 확인하세요.")
			dw_ip.setitem(dw_ip.getrow(), "p1_master_empno", snull)
			dw_ip.setitem(dw_ip.getrow(), "p1_master_empname", snull)
			dw_ip.setcolumn("p1_master_empno")
			dw_ip.setfocus()
			return 
		else
			dw_ip.setitem(dw_ip.getrow(), "p1_master_empname", s_empname)
		end if
	end if 
end if

if this.getcolumnname() =  "p1_chuljang_frdate" then
	s_frdate = this.gettext()
	if f_datechk(s_frdate) = -1 then
		messagebox("확인", "유효한 일자가 아닙니다. 출장일을 확인하십시오.")
		this.setcolumn("p1_chuljang_frdate")
		this.setfocus()
	end if 
end if
		
	
		



			 
			 
		
end event

event itemerror;return 1
end event

type dw_1 from datawindow within w_pya2010
event ue_key pbm_dwnkey
event ue_enter pbm_dwnprocessenter
integer x = 2171
integer y = 412
integer width = 2048
integer height = 1804
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_pya2010_2"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_enter;send(handle(this), 256, 9, 0)

return 1
end event

event itemchanged;string s_empno, s_empname, snull

setnull(snull)

if this.getcolumnname() = "p1_master_empno" then
	s_empno = this.gettext()
	
	SELECT "P1_MASTER"."EMPNAME"
	  INTO :s_empname         
	  FROM "P1_MASTER"
	 WHERE "P1_MASTER"."EMPNO" = :s_empno ;
	  
	dw_1.setitem(dw_1.getrow(), "p1_master_empname", s_empname)
//	dw_list.triggerevent(clicked!)
   dw_1.retrieve(s_empno, '%')
 
end if	 
		 
//if wf_requiredchk(dw_1.getrow()) = -1 then return

	 
end event

event itemerror;return 1
end event

event rbuttondown;string s_ename, s_Code

SetNull(Gs_code)
SetNull(Gs_codename)

if dw_1.AcceptText() = -1 then return

IF dw_1.getcolumnname() = "p1_master_empno" THEN
	gs_Code = this.GetText()
	
	open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
		
  SELECT "P1_MASTER"."EMPNAMEENG"  
    INTO :s_ename  
    FROM "P1_MASTER"  
   WHERE "P1_MASTER"."EMPNO" = :gs_code ;
		
	dw_1.SetItem(dw_1.getrow(), "p1_master_empno", Gs_code)
   dw_1.SetItem(dw_1.getrow(), "p1_master_empname", Gs_codename)
	if IsNull(s_ename) or s_ename = '' then
	else
	 dw_1.setitem(dw_1.getrow(), "p1_master_empnameeng", s_ename)
   end if
//	if	dw_1.retrieve(gs_code) <= 0 then
//		dw_1.insertrow(0)
//		dw_1.SetItem(dw_1.getrow(), "p1_master_empno", Gs_code)
//      dw_1.SetItem(dw_1.getrow(), "p1_master_empname", Gs_codename)
//		dw_1.setitem(dw_1.getrow(), "p1_master_empnameeng", s_ename)
//		return 
//	end if
//	dw_1.TriggerEvent(ItemChanged!)
   dw_1.retrieve(Gs_code,'%')
END IF

end event

type dw_list from u_d_popup_sort within w_pya2010
integer x = 398
integer y = 552
integer width = 1499
integer height = 1508
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pya2010_1"
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;String s_deptcode, s_gradecode, s_empno, s_frdate
Long lRow

If Row <= 0 then
	dw_list.SelectRow(0,False)
	b_flag =True
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	lrow = dw_list.getclickedrow()
	
	if lrow <= 0 then return 
	
	s_deptcode = dw_list.getitemstring(lrow, "p0_dept_deptcode")
	s_gradecode = dw_list.getitemstring(lrow, "p1_master_gradecode")
	s_empno = dw_list.GetItemString(lrow,"p1_master_empno")
	s_frdate = dw_list.GetItemString(lrow,"p1_chuljang_frdate")
	
	if dw_1.retrieve(s_empno, s_frdate) <= 0 then
		dw_1.insertrow(0)
		dw_1.setfocus()
	   return 
	end if
	b_flag = False
	
  dw_ip.retrieve(s_deptcode, s_gradecode, s_empno, s_frdate)
END IF

CALL SUPER ::CLICKED
//
//sle_msg.text = ''
//if row <=0 then return
//
//this.SelectRow(0,False)
//this.SelectRow(row,True)
//
//s_empno = this.GetItemString(row,"p1_chuljang_empno")
//			 
//dw_1.SetItem(dw_1.getrow(),"p1_chuljang_empno",s_empno)
//
//ll_Row = dw_1.Retrieve(s_empno)
//IF ll_Row = 0 THEN
//	dw_1.InsertRow(0)
//END IF	
//
//cb_delete.Enabled = True
//
end event

event losefocus;call super::losefocus;return 1
end event

type rr_1 from roundrectangle within w_pya2010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 370
integer y = 540
integer width = 1550
integer height = 1540
integer cornerheight = 40
integer cornerwidth = 55
end type

