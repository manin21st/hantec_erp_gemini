$PBExportHeader$w_sys_001.srw
$PBExportComments$Attention MENU
forward
global type w_sys_001 from Window
end type
type dw_1 from datawindow within w_sys_001
end type
end forward

global type w_sys_001 from Window
int X=0
int Y=4
int Width=1262
int Height=936
long BackColor=8421504
WindowType WindowType=response!
dw_1 dw_1
end type
global w_sys_001 w_sys_001

type variables
Long iLrow
end variables

forward prototypes
public subroutine wf_pgm (long arg_row)
end prototypes

public subroutine wf_pgm (long arg_row);String sname, spass

sName = trim(dw_1.GetItemString( arg_row, "window_id" ))
sPass = trim(dw_1.GetItemString( arg_row, "password" ))

IF sPass ="" OR IsNull(sPass) THEN
ELSE
	OpenWithParm(W_PGM_PASS,spass)
	
	IF Message.StringParm = "CANCEL" THEN RETURN
	
END IF

// 윈도우별 PASSWORD 확인
str_win		str_winname

// 윈도우 OPEN
str_winname.name = sName

gs_gubun = 'ATTENTION' 

OpenWithParm(str_winname.window, str_winname.name, sName) 
close(this)
end subroutine

on w_sys_001.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on w_sys_001.destroy
destroy(this.dw_1)
end on

event open;String wins
Long   Lrow, Lx

this.x = Parentwindow().x + 800
this.y = Parentwindow().y + 200

wins = parentwindow().classname()

dw_1.settransobject(sqlca)
If dw_1.retrieve(gs_userid, wins) > 0 then
	For Lrow = 1 to dw_1.rowcount()
		 dw_1.setitem(Lrow, "gubun", 2)	
	NExt
	
	iLrow = 1
	dw_1.setitem(1, "gubun", 1)
	dw_1.setrow(1)
	dw_1.scrolltorow(1)
	dw_1.setfocus()
Else
	Messagebox("Attention", "관련된 메뉴가 없읍니다", stopsign!)
	close(this)
end if
end event

type dw_1 from datawindow within w_sys_001
event ue_key pbm_dwnkey
event zu_2 pbm_dwnmousemove
int Width=1253
int Height=928
int TabOrder=10
string DataObject="d_sys_001"
boolean Border=false
boolean LiveScroll=true
end type

event ue_key;//this.selectrow(0, false)
this.setredraw(false)
Choose case key
		 case keyescape!
				close(parent)
				return
		 case keyuparrow!
				If iLrow = 1 then return
				this.setitem(iLrow, "gubun", 2)
				iLrow -= 1
		 case keydownarrow!
				this.setitem(iLrow, "gubun", 2)
				If iLrow = this.rowcount() then return
				iLrow++
		 case keyenter!
			   wf_pgm(this.getrow())
				return
end choose

//this.selectrow(iLrow, true)
this.setitem(iLrow, "gubun", 1)
this.accepttext()
//this.scrolltorow(iLrow)
this.setredraw(true)
this.setfocus()

end event

event zu_2;if row > 0 then
	this.setredraw(false)
	this.setitem(iLrow, "gubun", 2)
	iLrow = row
	this.setitem(iLrow, "gubun", 1)
	this.accepttext()
	this.setredraw(true)
end if
end event

event clicked;if row > 0 then
	this.setredraw(false)
	this.setitem(iLrow, "gubun", 2)
	iLrow = row
	this.setitem(iLrow, "gubun", 1)
	this.accepttext()
	this.setredraw(true)
	
	wf_pgm(ilrow)	
end if



end event

