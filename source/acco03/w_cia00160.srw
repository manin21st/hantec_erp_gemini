$PBExportHeader$w_cia00160.srw
$PBExportComments$원가수불부
forward
global type w_cia00160 from w_standard_print
end type
type rr_1 from roundrectangle within w_cia00160
end type
end forward

global type w_cia00160 from w_standard_print
string title = "원가수불부"
rr_1 rr_1
end type
global w_cia00160 w_cia00160

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sYm, eYm, sSaup_Gubn,sPum_Gubn,sItcls,sItnbr,scost_sabu,scost_nm

IF dw_ip.AcceptText() = -1 THEN RETURN -1

sYm        = TRIM(dw_ip.GetItemString(1,"io_yymm"))    /*원가계산년월from*/ 
eYm        = TRIM(dw_ip.GetItemString(1,"to_yymm"))    /*원가계산년월to*/ 
sSaup_Gubn = dw_ip.GetItemString(1,"saupgubn")   /*사업부구분*/
sPum_Gubn  = dw_ip.GetItemString(1,"pum_gubn")   /*품목구분*/
sItcls     = dw_ip.GetItemString(1,"itcls")      /*품질분류*/ 
sItnbr     = dw_ip.GetItemString(1,"itnbr")      /*품번*/ 
//---------------------------------------------------
scost_sabu = dw_ip.GetITemString(1,"cost_sabu") 

IF scost_sabu = '99' or scost_sabu = '' or isnull(scost_sabu) THEN
   scost_sabu = '%'
END IF

select rfna1		
into :scost_nm	
from reffpf 
where rfgub  = :scost_sabu and
		sabu = '1'	and 
		rfcod = 'C0';
//----------------------------------------------------
IF sYm = '' or isnull(sYm) THEN
   f_messagechk(1,'[원가계산년월]')
	dw_ip.SetColumn("io_yymm")
	dw_ip.SetFocus()
	Return -1	
ELSE
	IF F_DATECHK(sYm + '01') = -1 THEN
		f_messagechk(21,'[원가계산년월]')
	   dw_ip.SetColumn("io_yymm")
	   dw_ip.SetFocus()
	   Return -1	 
  END IF	
END IF

IF eYm = '' or isnull(eYm) THEN
   f_messagechk(1,'[원가계산년월]')
	dw_ip.SetColumn("to_yymm")
	dw_ip.SetFocus()
	Return -1	
ELSE
	IF F_DATECHK(eYm + '01') = -1 THEN
		f_messagechk(21,'[원가계산년월]')
	   dw_ip.SetColumn("to_yymm")
	   dw_ip.SetFocus()
	   Return -1	 
  END IF	
END IF


IF sSaup_Gubn = '' OR  ISNULL(sSaup_Gubn) THEN
	sSaup_Gubn = '%'
END IF	
IF sPum_Gubn = '' OR  ISNULL(sPum_Gubn) THEN
	f_messagechk(1,'[품목구분]')
	dw_ip.SetColumn("pum_gubn")
	dw_ip.SetFocus()
	Return -1	
END IF	
IF sItcls = '' OR  ISNULL(sItcls) THEN
	sItcls = '%'
END IF	

IF sItnbr = '' OR ISNULL(sItnbr) THEN
	sItnbr = '%'
END IF	

IF dw_print.Retrieve(scost_sabu,scost_nm,sYm,eym, sSaup_Gubn,sPum_Gubn,sItcls,sItnbr) <= 0 THEN
	f_messagechk(14,"") 
	Return -1 	
END IF 	
dw_print.ShareData(dw_list)
Return 1
end function

on w_cia00160.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_cia00160.destroy
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

Long rtncode

dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

DataWindowChild state_child

rtncode = dw_ip.GetChild('itcls', state_child)
state_child.SetTransObject(SQLCA)
state_child.Retrieve("1")
dw_ip.InsertRow(0)

dw_ip.SetITem(1,"io_yymm",Left(f_today(),6))
dw_ip.SetITem(1,"to_yymm",Left(f_today(),6))
	
dw_ip.SetITem(1,"pum_gubn",'1')	

dw_ip.SetColumn("io_yymm")
dw_ip.SetFocus()
end event

type p_preview from w_standard_print`p_preview within w_cia00160
end type

type p_exit from w_standard_print`p_exit within w_cia00160
end type

type p_print from w_standard_print`p_print within w_cia00160
end type

type p_retrieve from w_standard_print`p_retrieve within w_cia00160
end type







type st_10 from w_standard_print`st_10 within w_cia00160
end type



type dw_print from w_standard_print`dw_print within w_cia00160
integer y = 48
string dataobject = "dw_cia00160_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_cia00160
integer x = 32
integer y = 12
integer width = 3712
integer height = 200
string dataobject = "dw_cia00160_1"
end type

event dw_ip::itemerror;Return 1
end event

event dw_ip::itemchanged;DataWindowChild state_child
Long rtncode
String Saup_Gubn,snull,sItnbr,sNo,spdtgu,spdt_name, &
       sittyp,sittypname,sitcls 

SetNull(snull)
This.AcceptText()


IF this.GetColumnName() = "saupgubn" THEN  /*사업부구분*/
	spdtgu = this.GetText()
	IF spdtgu= "" OR IsNull(spdtgu) THEN RETURN
	
   SELECT"REFFPF"."RFNA1" INTO :spdt_name
    FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = 'C7' ) AND  
         ( "REFFPF"."RFGUB" = :spdtgu ) ;
			
	If Sqlca.Sqlcode <> 0 then
		f_messageChk(20,'[사업구분]')
		this.Setitem(this.getrow(),"saupgubn",snull)
		this.SetColumn("saupgubn")
		this.SetFocus()
		Return 1
	end if
END IF

IF This.GetColumnName() = "pum_gubn" THEN  /*품목구분*/
   sittyp = This.GetText()
   SELECT"REFFPF"."RFNA1" INTO :sittypname
    FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = '05' ) AND  
         ( "REFFPF"."RFGUB" = :sittyp )  ;
			
	If Sqlca.Sqlcode <> 0 then
		f_messageChk(20,'[품목구분]')
		this.Setitem(this.getrow(),"pum_gubn",snull)
		this.SetColumn("pum_gubn")
		this.SetFocus()
		Return 1
	end if
   /*품목분류  Retrieve*/
	//Saup_Gubn   = This.GetText()
	IF dw_ip.GetChild('itcls', state_child) = 1 THEN
	 	state_child.SetTransObject(SQLCA)
	   state_child.Retrieve(sittyp)
	END IF	
END IF	

IF this.GetColumnName() = "itcls" THEN
	sittyp = this.getitemstring(this.getrow(),"pum_gubn")
	sitcls = this.GetText()
	IF sitcls= "" OR IsNull(sitcls) THEN RETURN
	
	 SELECT "ITNCT"."ITCLS"   INTO :sitcls  
      FROM "ITNCT"  
     WHERE ( "ITNCT"."ITTYP" = :sittyp ) AND  
           ( "ITNCT"."ITCLS" = :sitcls ) AND  
           ( "ITNCT"."LMSGU" = 'M' )   ;
		
	If Sqlca.Sqlcode <> 0 then
		f_messageChk(20,'[품목분류]')
		this.Setitem(this.getrow(),"itcls",snull)
		this.SetColumn("itcls")
		this.SetFocus()
		Return 1
	end if
	
END IF

IF This.GetColumnName() = "itnbr" THEN
    sNo = This.GetText()
	 IF sNo = '' OR ISNULL(sNo) THEN 
   	 this.SetItem(Row,"itnbr_name",snull)
		 RETURN
	 END IF	 
	 SELECT "ITEMAS"."ITDSC"  
      INTO :sItnbr  
      FROM "ITEMAS" 
     WHERE "ITEMAS"."ITNBR" = :sNo ;
	  IF sItnbr = '' OR ISNULL(sItnbr) THEN  
	     f_messagechk(20,'[품번]')
		  this.SetItem(Row,"itnbr",snull)
		  this.SetItem(Row,"itnbr_name",snull)
		  Return 1 
     END IF
	  this.SetItem(Row,"itnbr_name",sItnbr)  
END IF
end event

event dw_ip::ue_pressenter;Send(Handle(This),256,9,0)
Return 1
end event

event dw_ip::rbuttondown;this.AcceptText()

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

IF this.GetColumnName() = "itnbr" THEN
   
	Open(W_ITEMAS_POPUP3)
      
   IF IsNull(gs_code) OR gs_code = "" THEN Return
	
	THIS.SetItem(THIS.GetRow(), "itnbr", gs_code)
	THIS.SetItem(THIS.GetRow(), "itnbr_name", gs_codename)
	
END IF	
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_cia00160
integer y = 224
integer width = 4558
integer height = 1996
string dataobject = "dw_cia00160_2"
boolean border = false
end type

event dw_list::doubleclicked;call super::doubleclicked;

if row <=0 then Return

String sArg

SelectRow(0,False)
SelectRow(row,True)

sArg =  this.GetItemString(row,"pdtgu") + dw_ip.GetItemString(1,"io_yymm") + this.GetItemString(row,"itnbr")

OpenWithParm(w_cia00161, sArg)

end event

type rr_1 from roundrectangle within w_cia00160
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 216
integer width = 4581
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 55
end type

