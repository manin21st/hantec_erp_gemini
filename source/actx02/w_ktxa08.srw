$PBExportHeader$w_ktxa08.srw
$PBExportComments$기타 부가세 신고용 출력물
forward
global type w_ktxa08 from w_standard_print
end type
type rr_1 from roundrectangle within w_ktxa08
end type
end forward

global type w_ktxa08 from w_standard_print
integer x = 0
integer y = 0
string title = "기타신고서 조회 출력"
rr_1 rr_1
end type
global w_ktxa08 w_ktxa08

type variables
String prt_gu
String  sGi_1,sGi_2
end variables

forward prototypes
public function integer wf_print ()
public subroutine wf_setting_cond ()
public function integer wf_retrieve ()
end prototypes

public function integer wf_print ();
//IF dw_list.RowCount() > 0 THEN
//	OpenWithParm(w_print_options,dw_list)
//END IF


Return 1
end function

public subroutine wf_setting_cond ();String snull, i_temp

SetNull(snull)

dw_ip.SetItem(dw_ip.GetRow(),"sjasa",snull)
dw_ip.SetItem(dw_ip.GetRow(),"stax",snull)


CHOOSE CASE prt_gu

	CASE "jasa_vat"
		
		//dw_ip.Modify("sjasa.background.color = '"+String(Rgb(192,192,192))+"'")
		dw_ip.Modify("sjasa.protect = 1")
	CASE "maiip_rpt"
		//dw_ip.Modify("sjasa.background.color = '"+String(Rgb(255,255,255))+"'")
		dw_ip.Modify("sjasa.protect = 0")	
	CASE "in_notax","gojeng"
		//dw_ip.Modify("sjasa.background.color = '"+String(Rgb(190,225,184))+"'")
		dw_ip.Modify("sjasa.protect = 0")	
	CASE 	"dis_title"
		//dw_ip.Modify("sjasa.background.color = '"+String(Rgb(255,255,255))+"'")
		dw_ip.Modify("sjasa.protect = 0")	
END CHOOSE
end subroutine

public function integer wf_retrieve ();String svatgisu,sJasa,saupj_name,sjasa_name,sStart,sEnd,sJasa_code,sYyyy,sCommJasa
Int i=0,j

IF sqlca.sqlcode <> 0 THEN RETURN -1

dw_ip.AcceptText()

w_mdi_frame.sle_msg.text =""

svatgisu = dw_ip.getitemstring(dw_ip.getrow(),"vatgisu")
sStart   = Trim(dw_ip.getitemstring(dw_ip.getrow(),"datef"))
sEnd     = Trim(dw_ip.getitemstring(dw_ip.getrow(),"datet"))
sJasa    = dw_ip.getitemstring(dw_ip.getrow(),"sjasa") 

IF sStart = "" OR IsNull(sStart) THEN
	F_MessageChk(1,'[거래기간]')
	dw_ip.SetColumn("datef")
	dw_ip.SetFocus()
	Return -1
END IF

IF sEnd = "" OR IsNull(sEnd) THEN
	F_MessageChk(1,'[거래기간]')
	dw_ip.SetColumn("datet")
	dw_ip.SetFocus()
	Return -1
END IF

SELECT "SYSCNFG"."DATANAME"  
   	INTO :sCommJasa  
    	FROM "SYSCNFG"  
   	WHERE ( "SYSCNFG"."SYSGU" = 'C' ) AND ( "SYSCNFG"."SERIAL" = 4 ) AND  
         	( "SYSCNFG"."LINENO" = '1' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	F_MessageChk(56,'[자사코드(C-4-1)]')
	dw_ip.SetColumn("sjasa")
	dw_ip.SetFocus()
	Return -1
ELSE
	IF IsNull(sCommJasa) OR sCommJasa = "" THEN
		F_MessageChk(56,'[자사코드(C-4-1)]')
		dw_ip.SetColumn("sjasa")
		dw_ip.SetFocus()
		Return -1
	END IF
END IF
	
sYyyy    = mid(sStart,1,4)

SELECT "RFNA1" 				INTO :saupj_name 
  FROM "REFFPF"
 WHERE ( "RFCOD" = 'AD' ) AND ( "RFGUB" = :sabu_f );
			
CHOOSE CASE prt_gu
		
	CASE "jasa_vat"												/*사업장별 과세표준*/
		dw_list.Reset()      
		j = dw_list.Retrieve(svatgisu,sStart,sEnd)
		IF j <= 0 THEN 											
			f_Messagechk(14,"") 
			Return -1
		ELSE
			DO UNTIL i + j = 14
				dw_list.Insertrow(0)
				i = i + 1
			LOOP
		END IF
	CASE "in_notax"											/*매입 불공제*/
		
		IF sJasa = "" OR IsNull(sJasa) THEN
			F_MessageChk(1,'[자사코드]')
			dw_ip.SetColumn("sjasa")
			dw_ip.SetFocus()
			Return -1
		END IF

		dw_list.Reset()      
		
		IF dw_list.Retrieve(sYyyy,sStart,sEnd,sJasa) <= 0 THEN 											
			f_Messagechk(14,"") 
			dw_list.insertrow(0)
			Return -1
		END IF
	CASE "gojeng"											/*사업실적*/
		IF sJasa = "" OR IsNull(sJasa) THEN
			F_MessageChk(1,'[자사코드]')
			dw_ip.SetColumn("sjasa")
			dw_ip.SetFocus()
			Return -1
		END IF

		dw_list.Reset()      
		j = dw_list.Retrieve(sStart,sEnd,sJasa)
		IF  j <= 0 THEN 											
			f_Messagechk(14,"") 
			Return -1
		ELSE
			DO UNTIL i + j = 23
				dw_list.Insertrow(0)
				i = i + 1
			LOOP
		END IF
	CASE "maiip_rpt"											/*의제매입공제*/
		IF sJasa = "" OR IsNull(sJasa) THEN
			F_MessageChk(1,'[자사코드]')
			dw_ip.SetColumn("sjasa")
			dw_ip.SetFocus()
			Return -1
		END IF
		
		dw_list.Reset()      
		
		j = dw_list.Retrieve(sJasa,sStart,sEnd)
		IF  j <= 0 THEN 											
			f_Messagechk(14,"") 
			
			Return -1
		ELSE
			DO UNTIL i + j = 21
				dw_list.Insertrow(0)
				i = i + 1
			LOOP
		END IF
	CASE "sub_lst"																	/*원료공급자*/
		IF sJasa = "" OR IsNull(sJasa) THEN
			F_MessageChk(1,'[자사코드]')
			dw_ip.SetColumn("sjasa")
			dw_ip.SetFocus()
			Return -1
		END IF
		
		dw_list.Reset()      
		
		IF dw_list.Retrieve(sJaSa,sStart,sEnd) <= 0 THEN 											
			f_Messagechk(14,"") 
			dw_list.insertrow(0)
			Return -1
		END IF
END CHOOSE	
dw_list.object.datawindow.print.preview = "yes"	

Return 1


end function

on w_ktxa08.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_ktxa08.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetItem(dw_ip.GetRow(),"saupj", gs_saupj)
dw_ip.SetItem(dw_ip.Getrow(),"sselect_gu",'1')

prt_gu ="jasa_vat"

Wf_Setting_Cond()

dw_ip.SetColumn("vatgisu")
dw_ip.SetFocus()
end event

type p_preview from w_standard_print`p_preview within w_ktxa08
boolean visible = false
integer x = 4448
integer y = 144
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within w_ktxa08
integer y = 0
integer taborder = 40
string pointer = ""
end type

type p_print from w_standard_print`p_print within w_ktxa08
integer y = 0
integer taborder = 30
string pointer = ""
end type

event p_print::clicked;IF dw_list.rowcount() > 0 then 
	gi_page = dw_list.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_list)


end event

type p_retrieve from w_standard_print`p_retrieve within w_ktxa08
integer x = 4096
integer y = 4
string pointer = ""
end type







type st_10 from w_standard_print`st_10 within w_ktxa08
end type



type dw_print from w_standard_print`dw_print within w_ktxa08
integer x = 3973
integer y = 148
integer width = 137
integer height = 104
string dataobject = "dw_ktxa08_p"
end type

type dw_ip from w_standard_print`dw_ip within w_ktxa08
integer x = 50
integer width = 3835
integer height = 232
string dataobject = "dw_ktxa081"
end type

event dw_ip::itemchanged;String  sSaupj,sSelectGbn,sVatGisu,sJasaCode,sTaxGbn,sStartDate,sEndDate,sNull
Integer iCurRow

SetNull(snull)

iCurRow = this.GetRow()

IF this.GetColumnName() = "sselect_gu" THEN
	sSelectGbn = this.GetText()
	
	IF sSelectGbn = '1' THEN
		prt_gu ="jasa_vat"

		dw_list.title ="사업장별 부가가치세 과세표준 및 납부세액(환급세액) 신고 명세서"
		dw_list.DataObject ="dw_ktxa08"
		dw_list.SetTransObject(SQLCA)
		dw_list.Reset()
		
	ELSEIF sSelectGbn = '2' THEN
		prt_gu ="in_notax"

		dw_list.title ="매입세액 불공제 명세서"
		dw_list.DataObject ="dw_ktxa082"
		dw_list.SetTransObject(SQLCA)
		dw_list.Reset()
		dw_list.InsertRow(0)
		
	ELSEIF sSelectGbn = '3' THEN
		prt_gu ="gojeng"

		dw_list.title ="사업설비투자실적명세서"
		dw_list.DataObject ="dw_ktxa083"
		dw_list.SetTransObject(SQLCA)
		dw_list.Reset()
		
	ELSEIF sSelectGbn = '4' THEN
		prt_gu ="dis_title"

		dw_list.title ="디스켓 제출 표지"
		dw_list.DataObject ="dw_ktxa084"
		dw_list.SetTransObject(SQLCA)
		dw_list.Reset()
	ELSEIF sSelectGbn = '5' THEN	
		prt_gu ="maiip_rpt"

		dw_list.title ="의제매입세액공제신고서"
		dw_list.DataObject ="dw_ktxa085"
		dw_list.SetTransObject(SQLCA)
		dw_list.Reset()
	ELSEIF sSelectGbn = '6' THEN
		prt_gu ="sub_lst"

		dw_list.title ="원료공급자명세"
		dw_list.DataObject ="dw_ktxa086"
		dw_list.SetTransObject(SQLCA)
		dw_list.Reset()
	END IF
	sle_msg.text =""
	
	Wf_Setting_Cond()
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
		SELECT SUBSTR("REFFPF"."RFNA1",1,2),SUBSTR("REFFPF"."RFNA1",3,2),
				 SUBSTR("REFFPF"."RFNA2",1,4),SUBSTR("REFFPF"."RFNA2",5,4)   
    		INTO  :sGi_1, :sGi_2, :sStartDate, :sEndDate  
		   FROM "REFFPF"  
   		WHERE ( "REFFPF"."RFCOD" = 'AV' ) AND ( "REFFPF"."RFGUB" = :sVatGisu )   ;
		this.SetItem(iCurRow,"datef",Left(f_Today(),4)+sStartDate)
		this.SetItem(iCurRow,"datet",Left(f_Today(),4)+sEndDate)
	END IF
END IF

IF this.GetColumnName() ="datef" THEN
	IF f_datechk(Trim(this.GetText())) = -1 THEN 
		f_messagechk(20,"기간")
		dw_ip.SetItem(1,"datef",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="datet" THEN
	IF f_datechk(Trim(this.GetText())) = -1 THEN 
		f_messagechk(20,"기간")
		dw_ip.SetItem(1,"datet",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="sjasa" THEN
	sJasaCode = this.GetText()
	IF sJasaCode = "" OR IsNull(sJasaCode) THEN Return
	
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

type dw_list from w_standard_print`dw_list within w_ktxa08
integer x = 73
integer y = 260
integer width = 4512
integer height = 1948
string title = "사업장별 부가가치세 과세표준 및 납부세액(환급세액) 신고 명세서"
string dataobject = "dw_ktxa08"
boolean hsplitscroll = false
end type

event dw_list::clicked;w_mdi_frame.sle_msg.text = ''
end event

event dw_list::rowfocuschanged;w_mdi_frame.sle_msg.text = ''
end event

type rr_1 from roundrectangle within w_ktxa08
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 248
integer width = 4549
integer height = 1972
integer cornerheight = 40
integer cornerwidth = 55
end type

