$PBExportHeader$w_kgld69b.srw
$PBExportComments$합계잔액시산표 상세 조회-장부 조회
forward
global type w_kgld69b from window
end type
type dw_2 from datawindow within w_kgld69b
end type
type dw_1 from datawindow within w_kgld69b
end type
type rr_1 from roundrectangle within w_kgld69b
end type
end forward

global type w_kgld69b from window
integer x = 46
integer y = 112
integer width = 4658
integer height = 2400
boolean titlebar = true
string title = "장부 조회"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
dw_2 dw_2
dw_1 dw_1
rr_1 rr_1
end type
global w_kgld69b w_kgld69b

on w_kgld69b.create
this.dw_2=create dw_2
this.dw_1=create dw_1
this.rr_1=create rr_1
this.Control[]={this.dw_2,&
this.dw_1,&
this.rr_1}
end on

on w_kgld69b.destroy
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;
String sMsgParm,sSaupj,sAcc,sCust,sFrAcc,sToAcc,sAccName,sYear,sMonth,sGbn6,sLevGu,sSaupjF,sSaupjT

F_Window_Center_Response(This)

sMsgParm = Message.StringParm

dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)

dw_1.Reset()
dw_1.Insertrow(0)

sSaupj  = Gs_Gubun
sYear   = Mid(sMsgParm,1,4)
sMonth  = Mid(sMsgParm,5,2)

sAcc    = Mid(sMsgParm,7,7)
sCust   = Mid(sMsgParm,14,20)

//IF sSaupj = '99' THEN
//	sSaupjF = '1';			sSaupjT = '98';
//ELSE
//	sSaupjF = sSaupj;		sSaupjT = sSaupj;
//END IF

select acc2_nm,		gbn6,		fracc1_cd||fracc2_cd,	toacc1_cd||toacc2_cd,	lev_gu
	into :sAccName, 	:sGbn6,	:sFrAcc,						:sToAcc,						:sLevGu 	
	from kfz01om0
	where acc1_cd||acc2_cd = :sAcc;

dw_1.SetItem(1,"saupj",   sSaupj)
dw_1.SetItem(1,"acc_ym",  sYear+sMonth)
dw_1.SetItem(1,"accno",   sAcc)
dw_1.SetItem(1,"accname", sAccName)

if sGbn6 = 'Y' THEN
	IF sCust = "" OR IsNull(sCust) then sCust = '%'
	
	this.Title = '거래처 원장'
	
	dw_2.SetRedraw(False)
	dw_2.DataObject = 'dw_kgld69b3'
	dw_2.SetTransObject(sqlca)
	dw_2.Reset()
	dw_2.SetRedraw(True)

	dw_2.Retrieve(sSaupj,sYear,sCust,sYear+sMonth+'01',sYear+sMonth+'31',sAcc,sFrAcc,sToAcc)
else
	dw_2.SetRedraw(False)
	IF sLevGu = '4' THEN									/*계정과목*/
		this.Title = '계정과목 보조장'
		dw_2.DataObject = 'dw_kgld69b21'
	ELSE
		this.Title = '계정세목 보조장'
		dw_2.DataObject = 'dw_kgld69b2'
	END IF
	dw_2.SetTransObject(sqlca)
	dw_2.Reset()
	dw_2.SetRedraw(True)
	
	dw_2.Retrieve(sSaupj,sYear,sFrAcc,sToAcc,sYear+sMonth+'01',sYear+sMonth+'31')
end if

end event

type dw_2 from datawindow within w_kgld69b
integer x = 64
integer y = 200
integer width = 4544
integer height = 2080
string dataobject = "dw_kgld69b2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event buttonclicked;s_Junpoy  str_AccJunpoy

IF dwo.name = 'dcb_junpoy' THEN										/*전표 조회*/
	
	str_AccJunPoy.saupjang = dw_1.GetItemString(1,"saupj")
	str_AccJunPoy.upmugu   = this.GetItemString(this.GetRow(),"upmugu")
	str_AccJunPoy.accdate  = Left(this.GetItemString(this.GetRow(),"acdat"),4) + &
									 Mid(this.GetItemString(this.GetRow(),"acdat"),6,2) + &
									 Right(this.GetItemString(this.GetRow(),"acdat"),2) 
	str_AccJunPoy.junno    = this.GetItemNumber(this.GetRow(),"jun_no")

	OpenWithParm(w_kgld69c,Str_AccJunpoy)
END IF
end event

type dw_1 from datawindow within w_kgld69b
integer x = 46
integer y = 12
integer width = 3872
integer height = 180
string dataobject = "dw_kgld69a1"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_kgld69b
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 192
integer width = 4571
integer height = 2100
integer cornerheight = 40
integer cornerwidth = 55
end type

