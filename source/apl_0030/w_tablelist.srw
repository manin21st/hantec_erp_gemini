$PBExportHeader$w_tablelist.srw
$PBExportComments$TABLE List Ãâ·Â
forward
global type w_tablelist from w_standard_print
end type
type st_1 from statictext within w_tablelist
end type
type sle_tablename from singlelineedit within w_tablelist
end type
type sle_owner from singlelineedit within w_tablelist
end type
end forward

global type w_tablelist from w_standard_print
boolean TitleBar=true
string Title="TABLE DESCRIPTION"
long BackColor=80793808
st_1 st_1
sle_tablename sle_tablename
sle_owner sle_owner
end type
global w_tablelist w_tablelist

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string	owner,table_name
int      nPos,nRow

//////////////////////////////////////////////////////////////////
If dw_ip.accepttext() <> 1 then Return -1

owner = trim(sle_owner.Text)
IF	IsNull(owner) or owner = '' then
	f_message_chk(1400,'[OWNER]')
	sle_owner.setfocus()
	Return -1
END IF

table_name = trim(sle_tablename.Text)
IF	IsNull(table_name) or table_name = '' then table_name = '%'

If Pos(table_name,'%') <= 0 Then
  table_name += '%'
End If

////////////////////////////////////////////////////////////////
dw_list.SetRedraw(False)

nRow = dw_list.retrieve(owner,table_name)
if nRow < 1	then
	f_message_chk(50,"")
	sle_tablename.setfocus()
	return -1
end if

dw_list.SetRedraw(True)

Return 1

end function

on w_tablelist.create
int iCurrent
call super::create
this.st_1=create st_1
this.sle_tablename=create sle_tablename
this.sle_owner=create sle_owner
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.sle_tablename
this.Control[iCurrent+3]=this.sle_owner
end on

on w_tablelist.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.sle_tablename)
destroy(this.sle_owner)
end on

event open;call super::open;sle_owner.Visible = false
end event

type dw_ip from w_standard_print`dw_ip within w_tablelist
int X=462
int Y=2296
int Width=622
int Height=312
end type

type dw_list from w_standard_print`dw_list within w_tablelist
string DataObject="d_tablelst"
end type

type st_1 from statictext within w_tablelist
int X=59
int Y=88
int Width=434
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="TABLE NAME"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=700
string FaceName="±¼¸²Ã¼"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type sle_tablename from singlelineedit within w_tablelist
int X=59
int Y=156
int Width=567
int Height=92
int TabOrder=30
boolean BringToTop=true
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
string Text="%"
TextCase TextCase=Upper!
long TextColor=33554432
int TextSize=-9
int Weight=400
string FaceName="±¼¸²Ã¼"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type sle_owner from singlelineedit within w_tablelist
int X=59
int Y=304
int Width=585
int Height=92
int TabOrder=20
boolean BringToTop=true
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
string Text="MIS"
TextCase TextCase=Upper!
long TextColor=33554432
int TextSize=-10
int Weight=400
string FaceName="±¼¸²Ã¼"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

