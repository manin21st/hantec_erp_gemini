$PBExportHeader$w_ktxa01.srw
$PBExportComments$부가세 명세서 조회 출력
forward
global type w_ktxa01 from w_standard_print
end type
type gb_4 from groupbox within w_ktxa01
end type
type rb_1 from radiobutton within w_ktxa01
end type
type rb_2 from radiobutton within w_ktxa01
end type
type rb_3 from radiobutton within w_ktxa01
end type
type rb_4 from radiobutton within w_ktxa01
end type
type rr_1 from roundrectangle within w_ktxa01
end type
end forward

global type w_ktxa01 from w_standard_print
string title = "부가세명세서 조회 출력"
gb_4 gb_4
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
rr_1 rr_1
end type
global w_ktxa01 w_ktxa01

type variables
String IsSelectGbn
end variables

forward prototypes
public function integer wf_print ()
public function integer wf_retrieve ()
end prototypes

public function integer wf_print ();
IF dw_list.RowCount() > 0 THEN
	OpenWithParm(w_print_options,dw_print)
END IF

Return 1
end function

public function integer wf_retrieve ();String svatgisu,sTax,sJasa,saupj_name,sjasa_name,stax_name,sStart,sEnd,sApplyflag,sCrtDate,eTax,selegbn

dw_ip.AcceptText()

sle_msg.text =""

sabu_f   = dw_ip.GetItemString(dw_ip.GetRow(),"saupj")
svatgisu = dw_ip.getitemstring(dw_ip.getrow(),"vatgisu")
sStart   = Trim(dw_ip.getitemstring(dw_ip.getrow(),"datef"))
sEnd     = Trim(dw_ip.getitemstring(dw_ip.getrow(),"datet"))
sTax     = dw_ip.getitemstring(dw_ip.getrow(),"stax")
eTax     = dw_ip.getitemstring(dw_ip.getrow(),"etax")
sJasa    = dw_ip.getitemstring(dw_ip.getrow(),"sjasa") 

IsSelectGbn = dw_ip.getitemstring(dw_ip.getrow(),"sselect_gu")
selegbn = dw_ip.GetItemString(dw_ip.getrow(),"elegbn")

IF sStart = "" OR IsNull(sStart) THEN
	F_MessageChk(1,'[거래기간]')	
	dw_ip.SetColumn("datef")
	dw_ip.SetFocus()
	Return -1 
END IF

CHOOSE CASE IsSelectGbn
	CASE '1'
		IF sTax = "" OR IsNull(sTax) THEN sTax = '11'
		If eTax = '' or IsNull(eTax) then eTax = '19'
		
		IF sJasa = "" OR IsNull(sJasa) THEN 
			sJasa = '%'
		ELSE
			SELECT "REFFPF"."RFNA1" 		INTO :sjasa_name 
				FROM "REFFPF"
				WHERE ( "REFFPF"."RFCOD" = 'JA' ) AND ( "REFFPF"."RFGUB" = :sJasa );
      END IF
		
		IF dw_print.Retrieve(stax,etax,sStart,sEnd,sjasa,saupj_name,sjasa_name,selegbn) <=0 THEN															
			f_Messagechk(14,"")
			Return -1
		END IF
	CASE '2'
		IF sTax = "" OR IsNull(sTax) THEN sTax = '21'
		If eTax = '' or IsNull(eTax) then eTax = '29'
		
		IF sJasa = "" OR IsNull(sJasa) THEN 
			sJasa = '%'
		ELSE
			SELECT "REFFPF"."RFNA1" 		INTO :sjasa_name 
				FROM "REFFPF"
				WHERE ( "REFFPF"."RFCOD" = 'JA' ) AND ( "REFFPF"."RFGUB" = :sJasa );
      END IF
		
		IF dw_print.Retrieve(stax,etax,sStart,sEnd,sjasa,saupj_name,sjasa_name,selegbn) <=0 THEN															
			f_Messagechk(14,"")
			Return -1
		END IF
	CASE '7'
		IF sTax = "" OR IsNull(sTax) THEN sTax = '11'
		If eTax = '' or IsNull(eTax) then eTax = '29'
		
		IF sJasa = "" OR IsNull(sJasa) THEN 
			sJasa = '%'
		ELSE
			SELECT "REFFPF"."RFNA1" 		INTO :sjasa_name 
				FROM "REFFPF"
				WHERE ( "REFFPF"."RFCOD" = 'JA' ) AND ( "REFFPF"."RFGUB" = :sJasa );
      END IF
		
		IF dw_print.Retrieve(stax,etax,sStart,sEnd,sjasa,saupj_name,sjasa_name,selegbn) <=0 THEN															
			f_Messagechk(14,"")			
			Return -1
		END IF		
	CASE '8'
		sjasa = dw_ip.GetItemString(dw_ip.GetRow(),"sjasa")
      IF sjasa ="" OR IsNull(sjasa) THEN sjasa ="%"
		
		sCrtDate = Trim(dw_ip.getitemstring(dw_ip.getrow(),"crtdate"))
		
		IF dw_print.Retrieve(sStart,sEnd,sjasa,svatgisu,sCrtDate) <=0 THEN															
			f_Messagechk(14,"")
			Return -1
		END IF
END CHOOSE	

dw_print.sharedata(dw_list)
w_mdi_frame.sle_msg.Text ="조회 완료했습니다.!!!"		
		
Return 1
end function

on w_ktxa01.create
int iCurrent
call super::create
this.gb_4=create gb_4
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_4
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_3
this.Control[iCurrent+5]=this.rb_4
this.Control[iCurrent+6]=this.rr_1
end on

on w_ktxa01.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_4)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rr_1)
end on

event open;ListviewItem		lvi_Current
lvi_Current.Data = Upper(This.ClassName())
lvi_Current.Label = This.Title
lvi_Current.PictureIndex = 1

w_mdi_frame.lv_open_menu.additem(lvi_Current)

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

DataWindowChild Dwc_VatGbn

dw_ip.GetChild("stax",Dwc_VatGbn)
Dwc_VatGbn.SetTransObject(Sqlca)
Dwc_VatGbn.Retrieve('1')

dw_ip.GetChild("etax",Dwc_VatGbn)
Dwc_VatGbn.SetTransObject(Sqlca)
Dwc_VatGbn.Retrieve('1')

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

String  sVatGisu,sStart,sEnd

dw_ip.SetItem(dw_ip.Getrow(),"sselect_gu",'1')

sVatGisu = F_Get_VatGisu(gs_saupj, f_today())

dw_ip.SetItem(dw_ip.GetRow(),"vatgisu",  sVatGisu)

SELECT SUBSTR("REFFPF"."RFNA2",1,4),	SUBSTR("REFFPF"."RFNA2",5,4)  /*부가세 기수에 해당하는 거래기간*/
	INTO :sStart,								:sEnd  
   FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = 'AV' ) AND  ( "REFFPF"."RFGUB" = :sVatGisu ) ;
	
dw_ip.SetItem(dw_ip.GetRow(),"datef",  Left(f_Today(),4)+sStart)
dw_ip.SetItem(dw_ip.GetRow(),"datet",  Left(f_Today(),4)+sEnd)
dw_ip.SetItem(dw_ip.GetRow(),"crtdate",F_today())

IsSelectGbn = '1'

dw_ip.SetColumn("vatgisu")
dw_ip.SetFocus()
end event

type p_xls from w_standard_print`p_xls within w_ktxa01
boolean visible = true
integer x = 4265
integer y = 164
end type

type p_sort from w_standard_print`p_sort within w_ktxa01
end type

type p_preview from w_standard_print`p_preview within w_ktxa01
integer x = 4091
end type

event p_preview::clicked;IF dw_list.RowCount() > 0 THEN
	OpenWithParm(w_print_preview,dw_print)
END IF


end event

type p_exit from w_standard_print`p_exit within w_ktxa01
integer x = 4439
end type

type p_print from w_standard_print`p_print within w_ktxa01
integer x = 4265
end type

event p_print::clicked;IF Wf_Print() = -1 then return
end event

type p_retrieve from w_standard_print`p_retrieve within w_ktxa01
integer x = 3918
end type





type dw_datetime from w_standard_print`dw_datetime within w_ktxa01
integer x = 2834
end type

type st_10 from w_standard_print`st_10 within w_ktxa01
end type

type gb_10 from w_standard_print`gb_10 within w_ktxa01
integer x = 55
integer y = 2932
integer width = 3584
integer height = 152
integer textsize = -12
fontcharset fontcharset = defaultcharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

type dw_print from w_standard_print`dw_print within w_ktxa01
integer x = 3931
integer y = 176
integer width = 160
integer height = 120
string dataobject = "dw_ktxa012_p"
end type

type dw_ip from w_standard_print`dw_ip within w_ktxa01
integer x = 23
integer y = 32
integer width = 2999
integer height = 276
string dataobject = "dw_ktxa011"
end type

event dw_ip::itemchanged;String  sSaupj,sVatGisu,sJasaCode,sTaxGbn,sStartDate,sEndDate,sNull
Integer iCurRow

SetNull(snull)

iCurRow = this.GetRow()

IF this.GetColumnName() = "sselect_gu" THEN
	IsSelectGbn = this.GetText()
	
	IF IsSelectGbn = '1' THEN		
		IF rb_1.Checked = True THEN
			dw_list.DataObject ="dw_ktxa012"
			dw_print.DataObject ="dw_ktxa012_p"
		ELSEIF rb_2.Checked = True THEN
			dw_list.DataObject ="dw_ktxa0121"
			dw_print.DataObject ="dw_ktxa0121_p"
		ELSE
			dw_list.DataObject ="dw_ktxa0122"
			dw_print.DataObject ="dw_ktxa0122_p"
		END IF
		
		dw_list.SetTransObject(SQLCA)
		dw_print.SetTransObject(SQLCA)
		
		rb_1.Enabled =True
		rb_2.Enabled =True
		rb_3.Enabled =True
		rb_4.Enabled =True
	ELSEIF IsSelectGbn = '2' THEN
		IF rb_2.Checked = True THEN
			dw_list.DataObject ="dw_ktxa013"
			dw_print.DataObject ="dw_ktxa013_p"
		ELSEIF rb_1.Checked = True THEN
			dw_list.DataObject ="dw_ktxa0131"
			dw_print.DataObject ="dw_ktxa0131_p"
		ELSE
			dw_list.DataObject ="dw_ktxa0132"
			dw_print.DataObject ="dw_ktxa0132_p"
		END IF
		dw_list.SetTransObject(SQLCA)
		dw_print.SetTransObject(SQLCA)
		
		rb_1.Enabled =True
		rb_2.Enabled =True
		rb_3.Enabled =True
		rb_4.Enabled =True
	ELSEIF IsSelectGbn = '7' THEN
		dw_list.DataObject ="dw_ktxa018"
		dw_list.SetTransObject(SQLCA)
		
		dw_print.DataObject ="dw_ktxa018_p"
		dw_print.SetTransObject(SQLCA)
		
		rb_1.Enabled =False
		rb_2.Enabled =False
		rb_3.Enabled =False
		rb_4.Enabled =False
	ELSEIF IsSelectGbn = '8' THEN		
		dw_list.DataObject ="dw_ktxa019"
		dw_list.SetTransObject(SQLCA)
		
		dw_print.DataObject ="dw_ktxa019_p"
		dw_print.SetTransObject(SQLCA)
		
		rb_1.Enabled =False
		rb_2.Enabled =False
		rb_3.Enabled =False
		rb_4.Enabled =False
	END IF
	
	this.SetItem(this.GetRow(),"stax",snull)
	this.SetItem(this.GetRow(),"etax",snull)
	
	DataWindowChild Dwc_VatGbn

	dw_ip.GetChild("stax",Dwc_VatGbn)
	Dwc_VatGbn.SetTransObject(Sqlca)
	Dwc_VatGbn.Retrieve(IsSelectGbn)
	
	dw_ip.GetChild("etax",Dwc_VatGbn)
	Dwc_VatGbn.SetTransObject(Sqlca)
	Dwc_VatGbn.Retrieve(IsSelectGbn)

	w_mdi_frame.sle_msg.text =""
	
END IF

IF this.GetColumnName() = "saupj" THEN
	sSaupj = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN RETURN
	
	IF IsNull(F_Get_Refferance('AD',sSaupj)) THEN
		F_MessageChk(20,'[사업장]')
		this.SetItem(iCurRow,"saupj",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "vatgisu" THEN
	sVatGiSu = this.GetText()
	IF sVatGisu = "" OR IsNull(sVatGiSu) THEN Return
	
	IF IsNull(F_Get_Refferance('AV',sVatGiSu)) THEN
		F_MessageChk(20,'[부가세기수]')
		this.SetItem(iCurRow,"vatgisu",snull)
		Return 1
	ELSE
		SELECT SUBSTR("REFFPF"."RFNA2",1,4),SUBSTR("REFFPF"."RFNA2",5,4)   
    		INTO :sStartDate,						:sEndDate  
		   FROM "REFFPF"  
   		WHERE ( "REFFPF"."RFCOD" = 'AV' ) AND  
         		( "REFFPF"."RFGUB" = :sVatGisu )   ;
		this.SetItem(iCurRow,"datef",Left(f_Today(),4)+sStartDate)
		this.SetItem(iCurRow,"datet",Left(f_Today(),4)+sEndDate)
	END IF
END IF

IF this.GetColumnName() ="sjasa" THEN
	sJasaCode = this.GetText()
	IF sJasaCode = "" OR IsNull(sJasaCode) THEN RETURN
		
	IF IsNull(F_Get_Refferance('JA',sJasaCode)) THEN
		F_MessageChk(20,'[자사코드]')
		this.SetItem(iCurRow,"sjasa",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="stax" THEN
	sTaxGbn = this.GetText()
	IF sTaxGbn ="" OR IsNull(sTaxGbn) THEN RETURN 

	IF IsNull(F_Get_Refferance('AT',sTaxGbn)) THEN
		F_MessageChk(20,'[부가세구분]')
		this.SetItem(iCurRow,"stax",snull)
		Return 1
	END IF
END IF


end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

event dw_ip::getfocus;this.AcceptText()
end event

type dw_list from w_standard_print`dw_list within w_ktxa01
integer x = 46
integer y = 324
integer width = 4562
integer height = 1880
string title = "매입장"
string dataobject = "dw_ktxa012"
boolean border = false
boolean hsplitscroll = false
end type

type gb_4 from groupbox within w_ktxa01
integer x = 3035
integer y = 8
integer width = 827
integer height = 284
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "정렬순서"
end type

type rb_1 from radiobutton within w_ktxa01
integer x = 3063
integer y = 68
integer width = 777
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "회계일자 전표번호순"
boolean checked = true
end type

event clicked;IF IsSelectGbn = '1' THEN
	dw_list.DataObject ="dw_ktxa012"	
	dw_print.DataObject ="dw_ktxa012_p"	
ELSEIF IsSelectGbn = '2' THEN
	dw_list.DataObject ="dw_ktxa013"
	dw_print.DataObject ="dw_ktxa013_p"	
END IF
dw_list.SetTransObject(SQLCA)
dw_list.Reset()
dw_print.SetTransObject(SQLCA)

p_retrieve.TriggerEvent(Clicked!)
end event

type rb_2 from radiobutton within w_ktxa01
integer x = 3063
integer y = 120
integer width = 777
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "사업자등록번호 회계일자순"
end type

event clicked;IF IsSelectGbn = '1' THEN
	dw_list.DataObject ="dw_ktxa0121"
	dw_print.DataObject ="dw_ktxa0121_p"	
ELSEIF IsSelectGbn = '2' THEN
	dw_list.DataObject ="dw_ktxa0131"
	dw_print.DataObject ="dw_ktxa0131_p"	
END IF
dw_list.SetTransObject(SQLCA)
dw_list.Reset()
dw_print.SetTransObject(SQLCA)

p_retrieve.TriggerEvent(Clicked!)
end event

type rb_3 from radiobutton within w_ktxa01
integer x = 3063
integer y = 176
integer width = 777
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "사업자등록번호순"
end type

event clicked;IF IsSelectGbn = '1' THEN
	dw_list.DataObject ="dw_ktxa0122"
	dw_print.DataObject ="dw_ktxa0122_p"	
ELSEIF IsSelectGbn = '2' THEN
	dw_list.DataObject ="dw_ktxa0132"
	dw_print.DataObject ="dw_ktxa0132_p"	
END IF
dw_list.SetTransObject(SQLCA)
dw_list.Reset()
dw_print.SetTransObject(SQLCA)

p_retrieve.TriggerEvent(Clicked!)
end event

type rb_4 from radiobutton within w_ktxa01
integer x = 3063
integer y = 232
integer width = 777
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "회계일자순"
end type

event clicked;IF IsSelectGbn = '1' THEN
	dw_list.DataObject ="dw_ktxa0123"
	dw_print.DataObject ="dw_ktxa0123_p"	
ELSEIF IsSelectGbn = '2' THEN
	dw_list.DataObject ="dw_ktxa0133"
	dw_print.DataObject ="dw_ktxa0133_p"	
END IF
dw_list.SetTransObject(SQLCA)
dw_list.Reset()
dw_print.SetTransObject(SQLCA)

p_retrieve.TriggerEvent(Clicked!)
end event

type rr_1 from roundrectangle within w_ktxa01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 312
integer width = 4594
integer height = 1904
integer cornerheight = 40
integer cornerwidth = 55
end type

