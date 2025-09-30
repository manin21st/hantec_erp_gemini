$PBExportHeader$w_seek.srw
$PBExportComments$object검색용 window
forward
global type w_seek from Window
end type
type cbx_1 from checkbox within w_seek
end type
type st_1 from statictext within w_seek
end type
type cb_1 from commandbutton within w_seek
end type
type dw_1 from datawindow within w_seek
end type
end forward

global type w_seek from Window
int X=1207
int Y=1680
int Width=1138
int Height=508
boolean TitleBar=true
string Title="검색"
long BackColor=79741120
boolean ControlMenu=true
WindowType WindowType=popup!
cbx_1 cbx_1
st_1 st_1
cb_1 cb_1
dw_1 dw_1
end type
global w_seek w_seek

type variables
datawindow dwname
integer iicount, ii
string sname[], stype[], sfind
long ilastrow
string start_name // 최초 시작 column
long  start_row     // 최초 시작 row
boolean start_check = False


end variables

forward prototypes
public subroutine wf_equal ()
public subroutine wf_like ()
end prototypes

public subroutine wf_equal ();/* Column별 자료 검색 */
dw_1.accepttext()

long lchk, lloop
startstep:
if ii = 0 or ii > iicount then ii = 1
if ilastrow = 0 or ilastrow > dwname.rowcount() then ilastrow = 1
if stype[ii] = 'char' then
	sfind = sname[ii] + " = '" + dw_1.getitemstring(1, "findvalue") + "'"
else
	if isnumber(dw_1.getitemstring(1, "findvalue")) then
		sfind = sname[ii] + " = " + dw_1.getitemstring(1, "findvalue") 
	else
			ilastrow = 1
			ii++
			lloop++
			if lloop > iicount - 1 then
				Messagebox("찾기", "일치하는 자료가 없읍니다")
				return
			end if
		goto startstep;
	end if
end if
lchk = dwname.find(sfind, ilastrow, dwname.rowcount())
if lchk >  1 then
	ilastrow = lchk
	Messagebox("찾기", "일치하는 자료가 없읍니다" + '~n' + &
							 "검색을 누르시면 처음부터 다시 검색합니다", information!)
	dwname.selectrow(0, false)
	dwname.scrolltorow(lchk)
	dwname.selectrow(lchk, true)
else
	ilastrow = 1
	ii++
	lloop++
	if lloop > iicount - 1 then
		Messagebox("찾기", "일치하는 자료가 없읍니다")
		return
	end if
	goto startstep;
end if


	

end subroutine

public subroutine wf_like ();/* Column별 자료 검색 */

long lchk, lloop, lsave
string sst, setting, sxfind
decimal {4} dst
startstep:
if ii = 0 or ii > iicount then 
	ii = 1
end if

if ilastrow = 0 or ilastrow > dwname.rowcount() then ilastrow = 0
sfind = dw_1.getitemstring(1, "findvalue") 
lchk = 0
ilastrow++
For lsave = ilastrow to dwname.rowcount()
	if start_check then
		if start_name = sName[ii] And start_row = lsave then
			lloop = 9999
			Start_check = False
			Exit
		end if
	end if
	if stype[ii] = 'char' then
		sst = dwname.getitemstring(lsave, sname[ii])
		lchk = pos(sst, sfind)
		if lchk > 0 then 
			lchk = lsave
			exit
		end if
	else
		dst = dwname.getitemdecimal(lsave, sname[ii])
		if dst = dec(sfind) then 
			lchk = lsave
			exit
		end if
	end if
Next
if lchk >  0 then
	Messagebox("찾기", "해당자료를 찾았읍니다")	
	
	if Not start_check then
		// 최초 시작지점 check
		start_name = sname[ii]
		start_row  = lsave
		start_check = true
	end if
	
	ilastrow = lchk
	dwname.selectrow(0, false)
	dwname.scrolltorow(lchk)
	dwname.selectrow(lchk, true)
	sxfind = sname[ii] + '.X'
	setting = dwname.Describe(sxfind)
	dwname.object.datawindow.horizontalscrollposition = Setting
	
//	modstring = "DataWindow.HorizontalScrollPosition=" + setting
//	dwname.Modify(modstring)	
	
else
	
	ilastrow = 0
	ii++
	lloop++
	if lloop > iicount - 1 then
		Messagebox("찾기", "일치하는 자료가 없읍니다" + '~n' + &
								 "검색을 누르시면 처음부터 다시 검색합니다", information!)
		start_row  = 0
		start_check = false
		return
	end if
	goto startstep;
end if


	

end subroutine

event open;
dwname = Message.powerobjectparm
dwname.Object.datawindow.horizontalscrollsplit = 0

string xx, stemp, sxtype
long lrow, lpos
xx = string(dwname.object.datawindow.column.count)
iicount = dec(xx)

for lrow = 1 to iicount
	 stemp 			= "#"+string(lrow)+".name"
	 sname[lrow]	= dwname.describe(stemp)
 	 stemp 			= "#"+string(lrow)+".coltype"
	 sxtype			= dwname.describe(stemp)	
	 lpos = 0
	 lpos				= pos(sxtype, '(')
	 if lpos > 0 then
		 sxtype = mid(sxtype, 1, lpos - 1)
	 End if
	 stype[lrow]   = sxtype
next

dw_1.insertrow(0)
end event

on w_seek.create
this.cbx_1=create cbx_1
this.st_1=create st_1
this.cb_1=create cb_1
this.dw_1=create dw_1
this.Control[]={this.cbx_1,&
this.st_1,&
this.cb_1,&
this.dw_1}
end on

on w_seek.destroy
destroy(this.cbx_1)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.dw_1)
end on

type cbx_1 from checkbox within w_seek
int X=288
int Y=104
int Width=439
int Height=76
string Text="일치자료 검색"
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=400
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type st_1 from statictext within w_seek
int X=27
int Y=208
int Width=1065
int Height=76
boolean Visible=false
boolean Enabled=false
string Text="자료를 검색중입니다.....!!"
boolean FocusRectangle=false
long TextColor=8388608
long BackColor=67108864
int TextSize=-9
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type cb_1 from commandbutton within w_seek
int X=14
int Y=288
int Width=1097
int Height=108
int TabOrder=20
string Text="검색(&F)"
boolean Default=true
int TextSize=-9
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

event clicked;string sprv, saft

SetPointer(HourGlass!)

st_1.visible = true

sprv = dw_1.getitemstring(1, "findvalue") 
dw_1.accepttext()
saft = dw_1.getitemstring(1, "findvalue") 

if trim(saft) = '' or isnull(saft) then 
	st_1.visible = False
	messagebox("확인", "검색 할 명을 입력하세요!")
   dw_1.setfocus()
	return 
end if	

if sprv <> saft then
	ii = 1 
	ilastrow = 0
	start_check = false
end if

if cbx_1.checked then 
	wf_equal()
else
   wf_like()
end if
st_1.visible = False
end event

type dw_1 from datawindow within w_seek
int Width=1125
int Height=116
int TabOrder=10
string DataObject="d_seek"
boolean Border=false
boolean LiveScroll=true
end type

