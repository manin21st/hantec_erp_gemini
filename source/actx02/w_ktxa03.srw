$PBExportHeader$w_ktxa03.srw
$PBExportComments$세무명세서 조회 출력
forward
global type w_ktxa03 from w_standard_print
end type
type rr_1 from roundrectangle within w_ktxa03
end type
end forward

global type w_ktxa03 from w_standard_print
integer x = 0
integer y = 0
string title = "세무명세서 조회 출력"
rr_1 rr_1
end type
global w_ktxa03 w_ktxa03

type variables
String prt_gu

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();//************************************************************************************//
String  sdatef, &
        sdatet, &
		  ssano,  &
		  scvnm, sJasa, sCrtDate, sDescr, sGisu, sTaxOffice, sSingoIn
Int     il_rowCount, &
        il_divrow, i
		  
dw_ip.AcceptText()

sle_msg.text =""

sdatef     = Trim(dw_ip.GetItemString(1,"sdate"))
sdatet     = Trim(dw_ip.GetItemString(1,"edate"))
sJasa    = dw_ip.GetItemString(1,"jasacd")
sCrtDate = Trim(dw_ip.GetItemString(1,"crtdate"))
sDescr   = dw_ip.GetItemString(1,"descr")
sGisu    = F_Get_VatGisu(gs_saupj,sdatef)
		
IF sDatef = "" OR IsNull(sDateF) THEN
	F_MessageChk(1,'[회계일자]')
	dw_ip.SetColumn("sdate")
	dw_ip.SetFocus()
	Return -1
END IF

IF sDatet = "" OR IsNull(sDatet) THEN
	F_MessageChk(1,'[회계일자]')
	dw_ip.SetColumn("edate")
	dw_ip.SetFocus()
	Return -1
END IF

IF DaysAfter(Date(sdatef),Date(sdatet)) < 0 THEN
	f_Messagechk(24,"")
	dw_ip.SetColumn("sdate")
	dw_ip.SetFocus()
	Return -1
END IF 

SELECT "VNDMST"."SANO", "VNDMST"."CVNAS"
	INTO :ssano,         :scvnm
   FROM "VNDMST","SYSCNFG"  
   WHERE "VNDMST"."CVCOD" = SUBSTR("SYSCNFG"."DATANAME",1,6) AND
			"SYSCNFG"."SYSGU" = 'C' AND
			"SYSCNFG"."SERIAL" = 4 AND "SYSCNFG"."LINENO" = '1';
			
CHOOSE CASE prt_gu
	CASE "won_myung" 	
		IF dw_print.Retrieve(sdatef,sdatet,ssano,scvnm) <=0 THEN
			f_MessageChk(14,"")
			//Return -1
		END IF
		
		dw_list.object.sdate_t.text = string(sdatef, '@@@@. @@. @@')
		dw_list.object.edate_t.text = string(sdatet, '@@@@. @@. @@')
		dw_list.object.sname_t.text = scvnm
		dw_list.object.sano_t.text = string(ssano, '@@@ - @@ - @@@@@')
		dw_print.object.sdate_t.text = string(sdatef, '@@@@. @@. @@')
		dw_print.object.edate_t.text = string(sdatet, '@@@@. @@. @@')
		dw_print.object.sname_t.text = scvnm
		dw_print.object.sano_t.text = string(ssano, '@@@ - @@ - @@@@@')
		
		dw_print.sharedata(dw_list)
		dw_list.SetRedraw(False)
		il_rowCount = dw_list.RowCount()
		il_divrow   =Mod(il_rowCount,33)
//		FOR i =il_divrow TO 32 
//			dw_list.InsertRow(0)
//		NEXT
		dw_list.SetRedraw(True)
		
	CASE "segum_myung"
		IF dw_print.Retrieve(sdatef,sdatet,ssano,scvnm) <=0 THEN
			f_MessageChk(14,"")
			//Return -1
		END IF
		
		dw_list.object.sdate_t.text = string(sdatef, '@@@@. @@. @@')
		dw_list.object.edate_t.text = string(sdatet, '@@@@. @@. @@')
		dw_list.object.sname_t.text = scvnm
		dw_list.object.sano_t.text = string(ssano, '@@@ - @@ - @@@@@')
		dw_print.object.sdate_t.text = string(sdatef, '@@@@. @@. @@')
		dw_print.object.edate_t.text = string(sdatet, '@@@@. @@. @@')
		dw_print.object.sname_t.text = scvnm
		dw_print.object.sano_t.text = string(ssano, '@@@ - @@ - @@@@@')
		
		dw_print.sharedata(dw_list)
		dw_list.SetRedraw(False)
		il_rowCount = dw_list.RowCount()
		il_divrow   =Mod(il_rowCount,33)
//		FOR i =il_divrow TO 32
//			dw_list.InsertRow(0)
//		NEXT
//		dw_list.Retrieve(sdatef,sdatet,ssano,scvnm)
		dw_list.SetRedraw(True)
		
	CASE "young_addreport"
		IF sJasa = "" OR IsNull(sJasa) THEN
			F_MessageChk(1,'[자사코드]')
			dw_ip.SetColumn("jasacd")
			dw_ip.SetFocus()
			Return -1
		END IF
		
		IF sCrtDate = "" OR IsNull(sCrtDate) THEN
			F_MessageChk(1,'[작성일자]')
			dw_ip.SetColumn("crtdate")
			dw_ip.SetFocus()
			Return -1
		END IF

		IF dw_print.Retrieve(sdatef,sdatet,sJasa, sGisu, sCrtDate,sDescr ) <=0 THEN
			f_MessageChk(14,"")
			//Return -1
		END IF
		dw_print.sharedata(dw_list)
	CASE "sinyongjang1"
		IF dw_print.Retrieve(sdatef,sdatet,sJasa, sGisu ) <=0 THEN
			f_MessageChk(14,"")
			//Return -1
		END IF
		dw_print.Object.t_crtdate.text = Mid(sCrtDate,1,4) + "년  " + Mid(sCrtDate,5,2) + "월  " + Mid(sCrtDate,7,2) + "일"
		
		dw_print.Object.t_sindat.text = Mid(sCrtDate,1,4) + " 년  " + Mid(sCrtDate,5,2) + " 월  " + Mid(sCrtDate,7,2) + " 일"
		
		select cvnas into :sSingoIn from vndmst where cvcod = :sJasa ;
		dw_print.Object.t_singoin.text = "제출인    " + sSingoIn 
		
		select rfna1 into :sTaxOffice from reffpf where rfcod = 'TO' and rfna2 = :sJasa ;
		dw_print.Object.t_tax_office.text = sTaxOffice 
		
		dw_print.sharedata(dw_list)
	CASE "sinyongjang2"
		IF dw_print.Retrieve(sdatef,sdatet,sJasa) <=0 THEN
			f_MessageChk(14,"")
			//Return -1
		END IF
		dw_print.sharedata(dw_list)
END CHOOSE

dw_list.Object.DataWindow.Print.Preview = 'yes'


Return 1
end function

on w_ktxa03.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_ktxa03.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetItem(dw_ip.Getrow(),"sdate",String(today(),"yyyymm01"))
dw_ip.SetItem(dw_ip.Getrow(),"edate",String(today(),"yyyymmdd"))
dw_ip.SetItem(dw_ip.Getrow(),"sselect_gu",'1')
dw_ip.SetFocus()

prt_gu ="won_myung"


end event

type p_preview from w_standard_print`p_preview within w_ktxa03
boolean visible = false
integer x = 4389
integer y = 184
integer taborder = 0
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within w_ktxa03
integer x = 4439
integer y = 8
integer taborder = 50
string pointer = ""
end type

type p_print from w_standard_print`p_print within w_ktxa03
integer x = 4265
integer y = 8
integer taborder = 40
string pointer = ""
end type

type p_retrieve from w_standard_print`p_retrieve within w_ktxa03
integer x = 4087
integer y = 8
string pointer = ""
end type







type st_10 from w_standard_print`st_10 within w_ktxa03
end type



type dw_print from w_standard_print`dw_print within w_ktxa03
integer x = 4174
integer y = 200
string dataobject = "dw_ktxa032_p"
end type

type dw_ip from w_standard_print`dw_ip within w_ktxa03
integer x = 9
integer width = 4050
integer height = 188
string dataobject = "dw_ktxa031"
end type

event dw_ip::itemchanged;
IF dwo.name = "sselect_gu" THEN
	CHOOSE CASE data
		CASE '1'
			prt_gu ="won_myung"

			dw_list.title ="원천납부세액 명세서"
			dw_list.DataObject ="dw_ktxa032"
			dw_list.SetTransObject(SQLCA)
			dw_list.Reset()
			dw_print.DataObject ="dw_ktxa032_p"
			dw_print.SetTransObject(SQLCA)
			dw_print.Reset()

		CASE '2'
			prt_gu ="segum_myung"

			dw_list.title ="세금과공과금 명세서"
			dw_list.DataObject ="dw_ktxa033"
			dw_list.SetTransObject(SQLCA)
			dw_list.Reset()
			dw_print.DataObject ="dw_ktxa033_p"
			dw_print.SetTransObject(SQLCA)
			dw_print.Reset()
			
		CASE '3'
			prt_gu ="young_addreport"

			dw_list.title ="영세율 첨부서류"
			dw_list.DataObject ="dw_ktxa24p2"
			dw_list.SetTransObject(SQLCA)
			dw_list.Reset()
			
		CASE '4'
			prt_gu ="sinyongjang1"

			dw_list.title ="내국신용장(갑)"
			dw_list.DataObject ="dw_ktxa24c"
			dw_list.SetTransObject(SQLCA)
			dw_list.Reset()
		CASE '5'
			prt_gu ="sinyongjang2"

			dw_list.title ="내국신용장(을)"
			dw_list.DataObject ="dw_ktxa24c2"
			dw_list.SetTransObject(SQLCA)
			dw_list.Reset()
			
	END CHOOSE
	sle_msg.text =""
END IF

end event

type dw_list from w_standard_print`dw_list within w_ktxa03
integer x = 32
integer y = 228
integer width = 4562
integer height = 2024
string title = "원천납부세액 명세서"
string dataobject = "dw_ktxa032"
boolean hscrollbar = false
boolean hsplitscroll = false
end type

event dw_list::clicked;w_mdi_frame.sle_msg.text = ''
end event

event dw_list::rowfocuschanged;w_mdi_frame.sle_msg.text = ''
end event

type rr_1 from roundrectangle within w_ktxa03
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 216
integer width = 4599
integer height = 2048
integer cornerheight = 40
integer cornerwidth = 55
end type

