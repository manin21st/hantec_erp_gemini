$PBExportHeader$w_pdt_02570.srw
$PBExportComments$** 품목할당현황(작업지시별,품목별)
forward
global type w_pdt_02570 from w_standard_print
end type
type ddlb_select from dropdownlistbox within w_pdt_02570
end type
type st_1 from statictext within w_pdt_02570
end type
type rr_1 from roundrectangle within w_pdt_02570
end type
end forward

global type w_pdt_02570 from w_standard_print
string title = "할당현황"
ddlb_select ddlb_select
st_1 st_1
rr_1 rr_1
end type
global w_pdt_02570 w_pdt_02570

forward prototypes
public function integer wf_retrieve ()
public function integer wf_retrieve_02570 ()
public function integer wf_retrieve_02580 ()
end prototypes

public function integer wf_retrieve ();int ireturn 

if ddlb_select.text = '작업지시별' then
	ireturn = wf_retrieve_02570()
else
	ireturn = wf_retrieve_02580()	
end if

return ireturn 
end function

public function integer wf_retrieve_02570 ();/* 작업지시별 할당현황 */
String  sNo1,sNo2,sDate, & 
        sChangGoNO,sChulGoGubn, &
		  GetDate, swkctr, ewkctr
		  
IF dw_ip.AcceptText() = -1 THEN RETURN -1

sNo1        = dw_ip.GetItemString(1,"sno1")  	//작업지시번호
sNo2        = dw_ip.GetItemString(1,"sno2")  	//작업지시번호
sDate       = trim(dw_ip.GetItemString(1,"date1")) 	//출고예정일
sChulGoGubn = dw_ip.GetItemString(1,"sgubn") 	//출고구분
sChangGoNO  = dw_ip.GetItemString(1,"scus")  	//창고번호
swkctr	   = dw_ip.GetItemString(1,"swkctr")  	//작업장
ewkctr	   = dw_ip.GetItemString(1,"ewkctr")  	//작업장

IF sNo1 = '' OR ISNULL(sNo1) THEN
	sNo1 = '.'
END IF	
IF sNo2 = '' OR ISNULL(sNo2) THEN
	sNo2 = 'ZZZZZZZZZZZZZZZZ'
END IF	
IF  sNo1 > sNo2 THEN
	 MessageBox("확인","작업지시번호범위를 확인하세요")
	 dw_ip.SetColumn("sno1")
	 dw_ip.SetFocus()
   return -1 
END IF 	

IF sDate = '' OR ISNULL(sDate) THEN
	sDate = '%'
END IF 

IF swkctr = '' OR ISNULL(swkctr) THEN
	swkctr = '.'
END IF 

IF ewkctr = '' OR ISNULL(ewkctr) THEN
	ewkctr = 'ZZZZZZZZZZZZZZz'
END IF 

IF sChangGoNO = '' OR ISNULL(sChangGoNO)  THEN
	sChanggono = '%'
END IF 	

IF sChulGoGubn = '%' THEN
   dw_list.setfilter("")
ELSE
   dw_list.setfilter("holdstock_hosts = 'N' and holdstock_unqty > 0")
END IF
dw_list.filter()

//IF dw_list.Retrieve(gs_sabu,sNo1,sNo2,sDate,sChangGoNO, swkctr, ewkctr) < 1 THEN
//	f_message_chk(50,'')
//	Return -1
//END IF	

IF dw_print.Retrieve(gs_sabu,sNo1,sNo2,sDate,sChangGoNO, swkctr, ewkctr) < 1 THEN
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1
end function

public function integer wf_retrieve_02580 ();/* 생산팀, 작업장별 할당현황 */
String  sDate1,sDate2, &
		  sChangGoNO,sGubn, &
		  GetDate, swkctr, ewkctr

IF dw_ip.AcceptText() = -1 THEN RETURN -1

sDate1      = TRIM(dw_ip.GetItemString(1,"sdate1"))  //출고예정일
sDate2      = TRIM(dw_ip.GetItemString(1,"sdate2"))  //출고예정일
sgubn		   = dw_ip.GetItemString(1,"sgubn")   //출고구분
sChangGoNO  = dw_ip.GetItemString(1,"scus") //창고번호
swkctr	   = dw_ip.GetItemString(1,"swkctr")  	//작업장
ewkctr	   = dw_ip.GetItemString(1,"ewkctr")  	//작업장

IF sdate1 = '' OR ISNULL(sdate1) THEN
	sDate1 = '10000101'
END IF	
IF sdate2 = '' OR ISNULL(sdate2) THEN
	sDate2 = '19991231'
END IF	
IF  sdate1 > sdate2 THEN
	 MessageBox("확인","출고예정일 범위를 확인하세요")
	 dw_ip.SetColumn("sdate1")
	 dw_ip.SetFocus()
   return -1 
END IF 	

IF sChangGoNO = '' OR ISNULL(sChangGoNO)  THEN
	sChanggono = '%'
END IF 	

IF swkctr = '' OR ISNULL(swkctr) THEN
	swkctr = '.'
END IF 

IF ewkctr = '' OR ISNULL(ewkctr) THEN
	ewkctr = 'ZZZZZZZZZZZZZZz'
END IF 

IF sgubn = '%' THEN
   dw_list.setfilter("")
ELSE
   dw_list.setfilter("holdstock_hosts = 'N' and holdstock_unqty > 0")
END IF
dw_list.filter()

//IF dw_list.Retrieve(gs_sabu,sDate1,sDate2,sChangGoNO, swkctr, ewkctr) < 1 THEN
//	f_message_chk(50,'')
//	Return -1
//END IF	

IF dw_print.Retrieve(gs_sabu,sDate1,sDate2,sChangGoNO, swkctr, ewkctr) < 1 THEN
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

Return 1
end function

on w_pdt_02570.create
int iCurrent
call super::create
this.ddlb_select=create ddlb_select
this.st_1=create st_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_select
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.rr_1
end on

on w_pdt_02570.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.ddlb_select)
destroy(this.st_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1, "date1", f_today())
ddlb_select.text = '작업지시별'
end event

type p_preview from w_standard_print`p_preview within w_pdt_02570
end type

type p_exit from w_standard_print`p_exit within w_pdt_02570
end type

type p_print from w_standard_print`p_print within w_pdt_02570
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_02570
end type







type st_10 from w_standard_print`st_10 within w_pdt_02570
end type

type gb_10 from w_standard_print`gb_10 within w_pdt_02570
boolean visible = false
integer x = 128
integer y = 2452
integer height = 144
integer textsize = -9
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

type dw_print from w_standard_print`dw_print within w_pdt_02570
string dataobject = "d_pdt_02570_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_02570
integer x = 27
integer y = 132
integer width = 3397
integer height = 188
integer taborder = 20
string dataobject = "d_pdt_02570_ret"
end type

event dw_ip::rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

Long  Curr_Row
Curr_Row  =  dw_ip.GetRow()
IF this.GetColumnName() = "scus" THEN
   Open(w_vndmst_popup)
   IF isnull(gs_code) OR gs_code = '' THEN RETURN

   dw_ip.SetItem(Curr_Row,"scus",gs_code)
   dw_ip.SetItem(Curr_Row,"scusname",gs_codename)
	
ELSEIF this.GetColumnName() = "sno1"	THEN	
	open(w_jisi_popup)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(1, "sno1", gs_Code)
	this.SetItem(1, "sno2", gs_Code)
   return 1
ELSEIF this.GetColumnName() = "sno2"	THEN	
	open(w_jisi_popup)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(1, "sno2", gs_Code)
   return 1
elseif this.getcolumnname() = "swkctr" then
   gs_code = this.gettext()
	open(w_workplace_popup)
	this.setitem(this.getrow(), "swkctr", gs_code)
	this.triggerevent(itemchanged!)
	setnull(gs_code)
	setnull(gs_codename)	
elseif this.getcolumnname() = "ewkctr" then
   gs_code = this.gettext()
	open(w_workplace_popup)
	this.setitem(this.getrow(), "ewkctr", gs_code)
	this.triggerevent(itemchanged!)
	setnull(gs_code)
	setnull(gs_codename)		
END IF	
end event

event dw_ip::ue_pressenter;send(handle(this), 256, 9, 0)

return 1
end event

event dw_ip::itemchanged;String  sCusName,sCusCode,SetNull,sName,sHal

IF THIS.GetColumnName() = "scus" THEN
	sCusCode = This.GetText()
	IF sCusCode = '' OR ISNULL(sCusCode) THEN
		dw_ip.SetItem(1,"scus",SetNull)
	   dw_ip.SetItem(1,"scusname",SetNull)
		RETURN
	END IF	
		
	SELECT VNDMST.CVNAS2
    INTO :sCusName
	 FROM VNDMST
   WHERE VNDMST.CVCOD = :sCusCode ;
	
	IF SQLCA.SQLCODE = 0 THEN
		dw_ip.SetItem(1,"scusname",sCusName)
	ELSE
	  MessageBox("확인","등록되어있는 창고가 아닙니다")
	  dw_ip.SetItem(1,"scus",SetNull)
	  dw_ip.SetItem(1,"scusname",SetNull)
	  dw_ip.SetColumn("scus")
	  dw_ip.SetFocus()
	  return 1 	
	END IF	
elseif THIS.GetColumnName() = "swkctr" THEN
	sCusCode = This.GetText()
	IF sCusCode = '' OR ISNULL(sCusCode) THEN
		dw_ip.SetItem(1,"swkctr",SetNull)
	   dw_ip.SetItem(1,"swkctr_name",SetNull)
		RETURN
	END IF	
	
	select wcdsc into :scusname from wrkctr where wkctr = :scuscode;
	IF SQLCA.SQLCODE = 0 THEN
		dw_ip.SetItem(1,"swkctr_name",sCusName)
	ELSE
	  MessageBox("확인","등록되어있는 작업장이아닙니다")
	  dw_ip.SetItem(1,"swkctr",SetNull)
	  dw_ip.SetItem(1,"swkctr_name",SetNull)
	  dw_ip.SetFocus()
	  return 1 	
	END IF		
elseif THIS.GetColumnName() = "ewkctr" THEN
	sCusCode = This.GetText()
	IF sCusCode = '' OR ISNULL(sCusCode) THEN
		dw_ip.SetItem(1,"ewkctr",SetNull)
	   dw_ip.SetItem(1,"ewkctr_name",SetNull)
		RETURN
	END IF	
	
	select wcdsc into :scusname from wrkctr where wkctr = :scuscode;
	IF SQLCA.SQLCODE = 0 THEN
		dw_ip.SetItem(1,"ewkctr_name",sCusName)
	ELSE
	  MessageBox("확인","등록되어있는 작업장이아닙니다")
	  dw_ip.SetItem(1,"ewkctr",SetNull)
	  dw_ip.SetItem(1,"ewkctr_name",SetNull)
	  dw_ip.SetFocus()
	  return 1 	
	END IF			
elseif THIS.GetColumnName() = "sno1" THEN
	sCusCode = This.GetText()
	
	IF sCusCode = '' OR ISNULL(sCusCode) THEN return 
	
	this.setitem(1, 'sno2', scuscode)
END IF	
end event

event dw_ip::itemerror;RETURN 1
end event

type dw_list from w_standard_print`dw_list within w_pdt_02570
integer y = 356
integer width = 4549
integer height = 1948
string title = "작업지시별"
string dataobject = "d_pdt_02570"
boolean controlmenu = true
boolean border = false
boolean hsplitscroll = false
end type

type ddlb_select from dropdownlistbox within w_pdt_02570
boolean visible = false
integer x = 370
integer y = 40
integer width = 695
integer height = 240
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean enabled = false
boolean vscrollbar = true
string item[] = {"작업지시별","품목별"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;if index = 1 then
	dw_ip.dataobject 		= 'd_pdt_02570_ret'
	dw_list.dataobject	= 'd_pdt_02570'
	dw_print.dataobject	= 'd_pdt_02570_p'
else
	dw_ip.dataobject 		= 'dw_pdt_02580_ret'
	dw_list.dataobject	= 'dw_pdt_02580'
end if

dw_ip.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_ip.insertrow(0)
if index = 1 then
	dw_ip.setitem(1, "date1", f_today())
else
	dw_ip.setitem(1, "sdate1", f_today())
	dw_ip.setitem(1, "sdate2", f_today())	
end if

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'

dw_ip.setfocus()

end event

type st_1 from statictext within w_pdt_02570
boolean visible = false
integer x = 87
integer y = 40
integer width = 279
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "출력구분"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_pdt_02570
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 348
integer width = 4571
integer height = 1976
integer cornerheight = 40
integer cornerwidth = 55
end type

