$PBExportHeader$w_ktxb04.srw
$PBExportComments$접대비 신고서 조회 출력
forward
global type w_ktxb04 from w_standard_print
end type
type tab_recp from tab within w_ktxb04
end type
type tabpage_recp_lst from userobject within tab_recp
end type
type rr_1 from roundrectangle within tabpage_recp_lst
end type
type dw_recp_lst from datawindow within tabpage_recp_lst
end type
type tabpage_recp_lst from userobject within tab_recp
rr_1 rr_1
dw_recp_lst dw_recp_lst
end type
type tab_recp from tab within w_ktxb04
tabpage_recp_lst tabpage_recp_lst
end type
end forward

global type w_ktxb04 from w_standard_print
integer x = 0
integer y = 0
integer width = 4663
string title = "접대비 신고서 조회 출력"
tab_recp tab_recp
end type
global w_ktxb04 w_ktxb04

type variables
Integer iCurTab = 1

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();//************************************************************************************//
String  sdatef, sdatet,ssano,  scvnm
Int     il_rowCount, il_divrow, i
		  
dw_ip.AcceptText()

w_mdi_frame.sle_msg.text =""

sdatef     = Trim(dw_ip.GetItemString(1,"sdate"))
sdatet     = Trim(dw_ip.GetItemString(1,"edate"))

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

if iCurTab = 1 then
	tab_recp.tabpage_recp_lst.dw_recp_lst.SetRedraw(False)
	tab_recp.tabpage_recp_lst.dw_recp_lst.Retrieve(sDatef,sDateT,sCvnm)
	
	il_rowCount = tab_recp.tabpage_recp_lst.dw_recp_lst.RowCount()
	il_divrow   =Mod(il_rowCount,12)
	FOR i =il_divrow TO 11 
		tab_recp.tabpage_recp_lst.dw_recp_lst.InsertRow(0)
	NEXT
	tab_recp.tabpage_recp_lst.dw_recp_lst.SetRedraw(True)
	tab_recp.tabpage_recp_lst.dw_recp_lst.Object.DataWindow.Print.Preview = "yes"
elseif iCurTab = 2 then
else
end if

//		il_rowCount = dw_list.RowCount()
//		il_divrow   =Mod(il_rowCount,33)
////		FOR i =il_divrow TO 32 
////			dw_list.InsertRow(0)
////		NEXT
//		dw_list.SetRedraw(True)
//		
//	CASE "segum_myung"
//		IF dw_print.Retrieve(sdatef,sdatet,ssano,scvnm) <=0 THEN
//			f_MessageChk(14,"")
//			//Return -1
//		END IF
//		
//		dw_list.object.sdate_t.text = string(sdatef, '@@@@. @@. @@')
//		dw_list.object.edate_t.text = string(sdatet, '@@@@. @@. @@')
//		dw_list.object.sname_t.text = scvnm
//		dw_list.object.sano_t.text = string(ssano, '@@@ - @@ - @@@@@')
//		
//		dw_print.sharedata(dw_list)
//		dw_list.SetRedraw(False)
//		il_rowCount = dw_list.RowCount()
//		il_divrow   =Mod(il_rowCount,33)
////		FOR i =il_divrow TO 32
////			dw_list.InsertRow(0)
////		NEXT
////		dw_list.Retrieve(sdatef,sdatet,ssano,scvnm)
//		dw_list.SetRedraw(True)
//		
//	CASE "sengup_myung"
//		IF dw_print.Retrieve(sdatef,sdatet,ssano,scvnm) <=0 THEN
//			f_MessageChk(14,"")
//			//Return -1
//		END IF
//		dw_print.sharedata(dw_list)
//		dw_list.SetRedraw(False)
//		il_rowCount = dw_list.RowCount()
//		il_divrow   =Mod(il_rowCount,31)
//		FOR i =il_divrow TO 30 
//			dw_list.InsertRow(0)
//		NEXT
//		dw_list.SetRedraw(True)
//		
//	CASE "misu_myung"
//		IF dw_list.Retrieve(sdatef,sdatet) <=0 THEN
//			f_MessageChk(14,"")
//			Return -1
//		END IF
//END CHOOSE


Return 1
end function

on w_ktxb04.create
int iCurrent
call super::create
this.tab_recp=create tab_recp
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_recp
end on

on w_ktxb04.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_recp)
end on

event open;call super::open;
dw_ip.SetItem(dw_ip.Getrow(),"sdate",String(today(),"yyyymm01"))
dw_ip.SetItem(dw_ip.Getrow(),"edate",String(today(),"yyyymmdd"))
dw_ip.SetFocus()

tab_recp.tabpage_recp_lst.dw_recp_lst.SetTransObject(Sqlca)
tab_recp.tabpage_recp_lst.dw_recp_lst.Reset()

iCurTab = 1

end event

type p_preview from w_standard_print`p_preview within w_ktxb04
boolean visible = false
integer x = 3369
integer y = 0
integer taborder = 40
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within w_ktxb04
integer x = 4343
integer y = 8
integer taborder = 60
string pointer = ""
end type

type p_print from w_standard_print`p_print within w_ktxb04
integer x = 4169
integer y = 8
integer taborder = 50
string pointer = ""
end type

type p_retrieve from w_standard_print`p_retrieve within w_ktxb04
integer x = 3995
integer y = 8
integer taborder = 20
string pointer = ""
end type







type st_10 from w_standard_print`st_10 within w_ktxb04
end type



type dw_print from w_standard_print`dw_print within w_ktxb04
integer y = 16
string dataobject = "dw_ktxa032_p"
end type

type dw_ip from w_standard_print`dw_ip within w_ktxb04
integer x = 114
integer y = 24
integer width = 1298
integer height = 140
integer taborder = 10
string dataobject = "dw_ktxb041"
end type

type dw_list from w_standard_print`dw_list within w_ktxb04
boolean visible = false
integer x = 1687
integer y = 12
integer width = 1152
integer height = 116
string dataobject = "dw_ktxa032"
boolean hscrollbar = false
boolean hsplitscroll = false
end type

type tab_recp from tab within w_ktxb04
integer x = 119
integer y = 172
integer width = 4421
integer height = 2036
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_recp_lst tabpage_recp_lst
end type

on tab_recp.create
this.tabpage_recp_lst=create tabpage_recp_lst
this.Control[]={this.tabpage_recp_lst}
end on

on tab_recp.destroy
destroy(this.tabpage_recp_lst)
end on

event selectionchanged;iCurTab = newindex

Wf_Retrieve()

end event

type tabpage_recp_lst from userobject within tab_recp
integer x = 18
integer y = 96
integer width = 4384
integer height = 1924
long backcolor = 32106727
string text = "접대비 명세서"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_1 rr_1
dw_recp_lst dw_recp_lst
end type

on tabpage_recp_lst.create
this.rr_1=create rr_1
this.dw_recp_lst=create dw_recp_lst
this.Control[]={this.rr_1,&
this.dw_recp_lst}
end on

on tabpage_recp_lst.destroy
destroy(this.rr_1)
destroy(this.dw_recp_lst)
end on

type rr_1 from roundrectangle within tabpage_recp_lst
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 8
integer width = 3758
integer height = 1912
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_recp_lst from datawindow within tabpage_recp_lst
integer x = 32
integer y = 20
integer width = 3730
integer height = 1868
integer taborder = 20
string dataobject = "dw_ktxb042_p"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

