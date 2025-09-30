$PBExportHeader$w_imt_03000_popup.srw
$PBExportComments$외자발주검토(기술 BOM 역전개 조회)
forward
global type w_imt_03000_popup from Window
end type
type dw_list from u_d_popup_sort within w_imt_03000_popup
end type
type cb_1 from commandbutton within w_imt_03000_popup
end type
type dw_1 from datawindow within w_imt_03000_popup
end type
type cb_exit from commandbutton within w_imt_03000_popup
end type
end forward

global type w_imt_03000_popup from Window
int X=416
int Y=100
int Width=3218
int Height=2228
boolean TitleBar=true
string Title="기술 BOM 역전개"
long BackColor=79741120
boolean ControlMenu=true
WindowType WindowType=response!
dw_list dw_list
cb_1 cb_1
dw_1 dw_1
cb_exit cb_exit
end type
global w_imt_03000_popup w_imt_03000_popup

type variables
string is_pspec, is_jijil
end variables

forward prototypes
public function integer wf_required_chk (integer i)
end prototypes

public function integer wf_required_chk (integer i);if dw_list.AcceptText() = -1 then return -1

if isnull(dw_list.GetItemNumber(i,'fno')) or &
	dw_list.GetItemNumber(i,'fno') = 0 then
	f_message_chk(1400,'[ '+string(i)+' 행 순번]')
	dw_list.ScrollToRow(i)
	dw_list.SetColumn('fno')
	dw_list.SetFocus()
	return -1		
end if	

Return 1

end function

on w_imt_03000_popup.create
this.dw_list=create dw_list
this.cb_1=create cb_1
this.dw_1=create dw_1
this.cb_exit=create cb_exit
this.Control[]={this.dw_list,&
this.cb_1,&
this.dw_1,&
this.cb_exit}
end on

on w_imt_03000_popup.destroy
destroy(this.dw_list)
destroy(this.cb_1)
destroy(this.dw_1)
destroy(this.cb_exit)
end on

event key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_list.scrollpriorpage()
	case keypagedown!
		dw_list.scrollnextpage()
	case keyhome!
		dw_list.scrolltorow(1)
	case keyend!
		dw_list.scrolltorow(dw_list.rowcount())
	case KeyupArrow!
		dw_list.scrollpriorrow()
	case KeyDownArrow!
		dw_list.scrollnextrow()		
end choose


end event

event open;string sitdsc, sispec, sdate, sjijil, sispec_code

dw_1.insertrow(0)

SELECT "ITDSC", "ISPEC", "JIJIL", "ISPEC_CODE"    
  INTO :sitdsc, :sispec, :sjijil, :sispec_code
  FROM "ITEMAS"  
 WHERE "ITNBR" = :gs_code   ;

sdate = gs_gubun + '01'

dw_1.setitem(1, 'itnbr', gs_code)
dw_1.setitem(1, 'itdsc', sitdsc)
dw_1.setitem(1, 'ispec', sispec)
dw_1.setitem(1, 'jijil', sjijil)
dw_1.setitem(1, 'ispec_code', sispec_code)
dw_1.setitem(1, 'sdate', sdate)


IF f_change_name('1') = 'Y' then 
	is_pspec = f_change_name('2')
	is_jijil = f_change_name('3')
		
	dw_1.object.ispec_t.text = is_pspec
	dw_1.object.jijil_t.text = is_jijil
	
	dw_list.object.ispec_t_low.text = '하위'+is_pspec
	dw_list.object.jijil_t_low.text = '하위'+is_jijil
	dw_list.object.ispec_t_high.text = '상위'+is_pspec
	dw_list.object.jijil_t_high.text = '상위'+is_jijil
	
END IF


dw_list.settransobject(sqlca)
dw_list.retrieve(gs_code, sdate)
	
	
	

end event

type dw_list from u_d_popup_sort within w_imt_03000_popup
int X=18
int Y=208
int Width=3141
int Height=1760
int TabOrder=20
string DataObject="d_imt_03000_popup"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
end type

event clicked;If Row <= 0 then
	SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event rowfocuschanged;SelectRow(0,False)
SelectRow(currentrow,True)

ScrollToRow(currentrow)
end event

type cb_1 from commandbutton within w_imt_03000_popup
int X=2487
int Y=1996
int Width=325
int Height=108
int TabOrder=30
string Text="조회(&R)"
int TextSize=-10
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

event clicked;string sitnbr, sdate

if dw_1.accepttext() = -1 then return 

sitnbr =  dw_1.getitemstring(1, 'itnbr')
sdate  =  trim(dw_1.getitemstring(1, 'sdate'))

if sdate = '' or isnull(sdate) then 
	f_message_chk(30,'[기준일자]')
	dw_1.SetFocus()
	RETURN
END IF

SetPointer(HourGlass!)

if dw_list.retrieve(sitnbr, sdate) < 1 then 
	f_message_chk(50, '')
	dw_1.setfocus()
end if

	
	
	

end event

type dw_1 from datawindow within w_imt_03000_popup
int X=32
int Y=16
int Width=3104
int Height=188
int TabOrder=10
string DataObject="d_imt_03000_popup2"
boolean Border=false
boolean LiveScroll=true
end type

type cb_exit from commandbutton within w_imt_03000_popup
int X=2834
int Y=1996
int Width=325
int Height=104
int TabOrder=40
string Text="닫기(&X)"
int TextSize=-10
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

event clicked;setnull(gs_code)
setnull(gs_gubun)

close(parent)
end event

