$PBExportHeader$w_kgld69bb.srw
$PBExportComments$예산집행명세서 상세 조회-장부 조회(조건:배정부서 추가)
forward
global type w_kgld69bb from window
end type
type dw_2 from datawindow within w_kgld69bb
end type
type dw_1 from datawindow within w_kgld69bb
end type
type rr_1 from roundrectangle within w_kgld69bb
end type
end forward

global type w_kgld69bb from window
integer x = 46
integer y = 112
integer width = 4622
integer height = 2408
boolean titlebar = true
string title = "전표 발생내역 조회"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
dw_2 dw_2
dw_1 dw_1
rr_1 rr_1
end type
global w_kgld69bb w_kgld69bb

on w_kgld69bb.create
this.dw_2=create dw_2
this.dw_1=create dw_1
this.rr_1=create rr_1
this.Control[]={this.dw_2,&
this.dw_1,&
this.rr_1}
end on

on w_kgld69bb.destroy
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;
String sMsgParm,sSaupj,sAcc,sDept,sAccName,sYear,sMonth

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
sDept   = Mid(sMsgParm,14)

select acc2_nm
	into :sAccName
	from kfz01om0
	where acc1_cd||acc2_cd = :sAcc;

dw_1.SetItem(1,"saupj",   sSaupj)
dw_1.SetItem(1,"acc_ym",  sYear+sMonth)
dw_1.SetItem(1,"accno",   sAcc)
dw_1.SetItem(1,"accname", sAccName)
dw_1.SetItem(1,"sdeptnm", sDept)

dw_2.SetRedraw(False)

dw_2.SetTransObject(sqlca)
dw_2.Reset()
dw_2.SetRedraw(True)

dw_2.Retrieve(sSaupj,sAcc,sYear+sMonth+'01',sYear+sMonth+'31',sDept)
end event

type dw_2 from datawindow within w_kgld69bb
integer x = 46
integer y = 200
integer width = 4512
integer height = 2080
string dataobject = "dw_kgld69bb2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event buttonclicked;s_Junpoy  str_AccJunpoy

IF dwo.name = 'dcb_junpoy' THEN										/*전표 조회*/
	
	str_AccJunPoy.saupjang = dw_1.GetItemString(1,"saupj")
	str_AccJunPoy.upmugu   = this.GetItemString(this.GetRow(),"upmu_gu")
	str_AccJunPoy.accdate  = this.GetItemString(this.GetRow(),"baldate")
	str_AccJunPoy.junno    = this.GetItemNumber(this.GetRow(),"jun_no")

	OpenWithParm(w_kgld69cc,Str_AccJunpoy)
END IF
end event

type dw_1 from datawindow within w_kgld69bb
integer x = 27
integer y = 12
integer width = 3849
integer height = 180
string dataobject = "dw_kgld69a1"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_kgld69bb
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 192
integer width = 4539
integer height = 2100
integer cornerheight = 40
integer cornerwidth = 55
end type

