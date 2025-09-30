$PBExportHeader$w_pdt_02531.srw
$PBExportComments$** 생산승인현황(영업용)
forward
global type w_pdt_02531 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_02531
end type
end forward

global type w_pdt_02531 from w_standard_print
string title = "생산승인/미승인 현황"
rr_1 rr_1
end type
global w_pdt_02531 w_pdt_02531

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sDate1,sDate2, spdtgu, steamcd, sarea ,sfilter, get_nm, get_nm2, sgub
int    ilen

if dw_ip.AcceptText() = -1 then return -1

sPdtgu  = dw_ip.GetItemString(1,"pdtgu")      //생산팀
steamcd = dw_ip.GetItemString(1,"deptcode")   //영업팀
sarea   = dw_ip.GetItemString(1,"areacode")   //관할구역
sDate1  = trim(dw_ip.GetItemString(1,"sdatef"))
sDate2  = trim(dw_ip.GetItemString(1,"sdatet"))
sGub    = dw_ip.GetItemString(1,"gub")  

IF sDate1 = '' OR ISNULL(sDate1) THEN  sDate1 = '10000101'
IF sDate2 = '' OR ISNULL(sDate2) THEN  sDate2 = '99991231'

IF sDate1 > sDate2 THEN
	MessageBox("확인","승인일자범위를 확인하세요")
	dw_ip.SetColumn("sdatef")
	dw_ip.SetFocus() 
	return -1
END IF	

IF sGub = '1'  THEN  //승인시
	dw_list.Dataobject = "dw_pdt_02530_5"
ELSE	
	dw_list.Dataobject = "dw_pdt_02530_6"
END IF
dw_list.SetTransObject(sqlca)

sfilter = ""

if not (spdtgu = ""	or isnull(spdtgu)) then	
   sfilter = "pdtgu = '"+ spdtgu +"' and " 
end if

if steamcd = ""	or isnull(steamcd) then	
   dw_print.object.txt1.text = "전 체"
else	
   sfilter = sfilter + "steamcd = '"+ steamcd +"' and " 

   SELECT "STEAM"."STEAMNM"  
     INTO :get_nm  
     FROM "STEAM"  
    WHERE "STEAM"."STEAMCD" = :steamcd   ;
	
   dw_list.object.txt1.text = get_nm
end if

if sarea = ""	or isnull(sarea) then	
   dw_print.object.txt2.text = "전 체"
else	
   sfilter = sfilter + "sarea = '"+ sarea +"' and " 

   SELECT "SAREA"."SAREANM"  
     INTO :get_nm2  
     FROM "SAREA"  
    WHERE "SAREA"."SAREA" = :sarea   ;

   dw_list.object.txt2.text = get_nm2
end if

ilen = len(sfilter) 

sfilter = left(sfilter, ilen - 4 )

dw_list.setfilter(sfilter)
dw_list.filter()

IF dw_list.Retrieve(gs_sabu,sDate1,sDate2) < 1 THEN
	f_message_chk(50,'')
	return -1		
END IF	

return 1
end function

on w_pdt_02531.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_02531.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1,'sdatef',F_today())
dw_ip.SetItem(1,'sdatet',F_today())

end event

type p_preview from w_standard_print`p_preview within w_pdt_02531
end type

type p_exit from w_standard_print`p_exit within w_pdt_02531
end type

type p_print from w_standard_print`p_print within w_pdt_02531
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_02531
end type







type st_10 from w_standard_print`st_10 within w_pdt_02531
end type

type gb_10 from w_standard_print`gb_10 within w_pdt_02531
boolean visible = false
integer x = 46
integer y = 2448
integer height = 144
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

type dw_print from w_standard_print`dw_print within w_pdt_02531
string dataobject = "dw_pdt_02530_5_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_02531
integer x = 32
integer y = 32
integer width = 3127
integer height = 188
string dataobject = "d_pdt_02531"
end type

event dw_ip::itemchanged;String  sIoCustArea,sDept,sDateFrom,sDateTo,snull

SetNull(snull)

Choose Case GetColumnName() 
 Case "sdatef"
	sDateFrom = Trim(this.GetText())
	IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
	
	IF f_datechk(sDateFrom) = -1 THEN
		f_message_chk(35,'[수주승인일자]')
		this.SetItem(1,"sdatef",snull)
		Return 1
	END IF
 Case "sdatet"
	sDateTo = Trim(this.GetText())
	IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
	
	IF f_datechk(sDateTo) = -1 THEN
		f_message_chk(35,'[수주승인일자]')
		this.SetItem(1,"sdatet",snull)
		Return 1
	END IF
/* 영업팀 */
 Case "deptcode"
   SetItem(1,'areacode',sNull)
/* 관할구역 */
 Case "areacode"
	
	sIoCustArea = this.GetText()
	IF sIoCustArea = "" OR IsNull(sIoCustArea) THEN RETURN
	
	SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sIoCustArea  ,:sDept
	  FROM "SAREA"  
	 WHERE "SAREA"."SAREA" = :sIoCustArea   ;
		
   SetItem(1,'deptcode',sDept)
END Choose

end event

event dw_ip::itemerror;
Return 1
end event

type dw_list from w_standard_print`dw_list within w_pdt_02531
integer x = 37
integer y = 240
integer width = 4562
integer height = 2068
string dataobject = "dw_pdt_02530_5"
boolean controlmenu = true
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_pdt_02531
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 232
integer width = 4585
integer height = 2088
integer cornerheight = 40
integer cornerwidth = 55
end type

