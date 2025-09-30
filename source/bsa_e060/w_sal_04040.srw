$PBExportHeader$w_sal_04040.srw
$PBExportComments$입금표 수령 및 개인배포/소손 등록
forward
global type w_sal_04040 from w_inherite
end type
type tab_1 from tab within w_sal_04040
end type
type tab1 from userobject within tab_1
end type
type gb_4 from groupbox within tab1
end type
type gb_3 from groupbox within tab1
end type
type dw_select1 from u_key_enter within tab1
end type
type rb_new from radiobutton within tab1
end type
type rb_old from radiobutton within tab1
end type
type dw_sarea1 from datawindow within tab1
end type
type gb_15 from groupbox within tab1
end type
type cb_mod1 from commandbutton within tab1
end type
type tab2 from userobject within tab_1
end type
type gb_2 from groupbox within tab2
end type
type gb_1 from groupbox within tab2
end type
type gb_6 from groupbox within tab2
end type
type gb_5 from groupbox within tab2
end type
type dw_select2 from u_key_enter within tab2
end type
type dw_sarea2 from datawindow within tab2
end type
type st_2 from statictext within tab2
end type
type dw_emp_id from datawindow within tab2
end type
type st_3 from statictext within tab2
end type
type st_4 from statictext within tab2
end type
type st_5 from statictext within tab2
end type
type st_6 from statictext within tab2
end type
type st_7 from statictext within tab2
end type
type st_8 from statictext within tab2
end type
type st_9 from statictext within tab2
end type
type cb_mod2 from commandbutton within tab2
end type
type gb_14 from groupbox within tab2
end type
type tab3 from userobject within tab_1
end type
type gb_12 from groupbox within tab3
end type
type gb_11 from groupbox within tab3
end type
type gb_9 from groupbox within tab3
end type
type dw_select3 from u_key_enter within tab3
end type
type dw_jogun from datawindow within tab3
end type
type cb_inq3 from commandbutton within tab3
end type
type gb_13 from groupbox within tab3
end type
type cb_mod3 from commandbutton within tab3
end type
type gb_7 from groupbox within w_sal_04040
end type
type tab1 from userobject within tab_1
gb_4 gb_4
gb_3 gb_3
dw_select1 dw_select1
rb_new rb_new
rb_old rb_old
dw_sarea1 dw_sarea1
gb_15 gb_15
cb_mod1 cb_mod1
end type
type tab2 from userobject within tab_1
gb_2 gb_2
gb_1 gb_1
gb_6 gb_6
gb_5 gb_5
dw_select2 dw_select2
dw_sarea2 dw_sarea2
st_2 st_2
dw_emp_id dw_emp_id
st_3 st_3
st_4 st_4
st_5 st_5
st_6 st_6
st_7 st_7
st_8 st_8
st_9 st_9
cb_mod2 cb_mod2
gb_14 gb_14
end type
type tab3 from userobject within tab_1
gb_12 gb_12
gb_11 gb_11
gb_9 gb_9
dw_select3 dw_select3
dw_jogun dw_jogun
cb_inq3 cb_inq3
gb_13 gb_13
cb_mod3 cb_mod3
end type
type tab_1 from tab within w_sal_04040
tab1 tab1
tab2 tab2
tab3 tab3
end type
end forward

global type w_sal_04040 from w_inherite
boolean TitleBar=true
string Title="입금표 수령 및 개인배포/소손 등록"
WindowState WindowState=normal!
tab_1 tab_1
gb_7 gb_7
end type
global w_sal_04040 w_sal_04040

type variables
DataWindow idw_select

long  il_sRow = 1

Integer ii_tab
end variables

forward prototypes
public function integer wf_mod_chk (string s1)
end prototypes

public function integer wf_mod_chk (string s1);/*=============================================================================================
		 1. window-level user function : 종료, 등록시 호출됨
		    dw_detail 의 typing(datawindow) 변경사항 검사

		 2. 계속진행할 경우 변경사항이 저장되지 않음을 경고                                                               

		 3. Argument:  s1 (warning messagebox)                                                                          
		    Return values:                                                   
                                                                  
      	*  1 : 변경사항을 저장하지 않고 계속 진행할 경우.
			* -1 : 진행을 중단할 경우.                      
=============================================================================================*/

IF ib_any_typing = true THEN  				// EditChanged event(dw_detail)의 typing 상태확인

	Beep(1)
	IF MessageBox("확인 : " + s1 , &
		 "저장하지 않은 값이 있습니다. ~r변경사항을 저장하시겠습니까", &
		 question!, yesno!) = 1 THEN

		RETURN -1									

	END IF

END IF
																
RETURN 1												// (dw_detail) 에 변경사항이 없거나 no일 경우
														// 변경사항을 저장하지 않고 계속진행 

end function

on w_sal_04040.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.gb_7=create gb_7
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.gb_7
end on

on w_sal_04040.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.gb_7)
end on

event open;call super::open;tab_1.tab1.dw_sarea1.SetTransObject(SQLCA)
tab_1.tab1.dw_select1.SetTransObject(SQLCA)
tab_1.tab2.dw_select2.SetTransObject(SQLCA)
tab_1.tab2.dw_sarea2.SetTransObject(SQLCA)
tab_1.tab2.dw_emp_id.SetTransObject(SQLCA)
tab_1.tab3.dw_Jogun.SetTransObject(SQLCA)
tab_1.tab3.dw_select3.SetTransObject(SQLCA)

tab_1.tab1.dw_sarea1.InsertRow(0)
tab_1.tab2.dw_sarea2.InsertRow(0)
//tab_1.tab2.dw_emp_id.InsertRow(0)
tab_1.tab2.dw_emp_id.Retrieve('%')

tab_1.tab3.dw_Jogun.InsertRow(0)

ib_any_typing = False

tab_1.SelectedTab = 1

tab_1.TriggerEvent(SelectionChanged!)
//tab_1.tab1.dw_sarea1.visible = False
//tab_1.tab1.rb_new.SetFocus()
//	
//tab_1.tab1.rb_new.TriggerEvent(Clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_sal_04040
int X=270
int Y=2328
int Width=1449
int Height=172
int TabOrder=10
boolean Visible=false
end type

type cb_exit from w_inherite`cb_exit within w_sal_04040
int X=3118
int Y=1940
int Width=398
int TabOrder=110
end type

type cb_mod from w_inherite`cb_mod within w_sal_04040
int X=2587
int Y=2388
int Width=398
int TabOrder=40
boolean Visible=false
end type

event cb_mod::clicked;call super::clicked;//Integer i
//String  sDstDate, sSarea, sRcvDate, sRcvEmp, sIpgNo
//Long    lFromNo, lToNo, lIpgNo, lrow = 0
//
//SetPointer(HourGlass!)
//sle_msg.Text = '관할구역별 수령일자 및 수령자 등록'
//
//if tab_1.tab1.dw_select1.Accepttext() = -1 then return
//
//for i = 1 to tab_1.tab1.dw_select1.RowCount()
//	sDstDate = tab_1.tab1.dw_select1.GetItemString(i, 'dst_date')
//	sSarea   = tab_1.tab1.dw_select1.GetItemString(i, 'sarea')
//	sRcvDate = tab_1.tab1.dw_select1.GetItemString(i, 'rcv_date')
//	sRcvEmp  = tab_1.tab1.dw_select1.GetItemString(i, 'rcvemp')	
//	lFromNo  = Long(tab_1.tab1.dw_select1.GetItemString(i, 'ipgnofrom'))
//	lToNo    = Long(tab_1.tab1.dw_select1.GetItemString(i, 'ipgnoto'))
//	
//	// 수령일자 및 수령자 등록된 ROW만 Update 처리
//	if not(sRcvDate = '' or isNull(sRcvDate)) then
//		if not(sRcvEmp = '' or isNull(sRcvEmp)) then
//
//      	Update ipgumpyo_dst 
//			Set    rcv_date = :sRcvDate, rcvemp = :sRcvEmp
//      	Where  dst_date = :sDstDate and sarea = :sSarea;
//			
//			if SQLCA.SqlCode = -1 then
//				f_message_chk(32, '[입금표수령 UPDATE(DST)]')
//				Rollback;
//				SetPointer(Arrow!)
//           	ib_any_typing = True
//				return
//			end if
//			
//   		for lIpgNo = lFromNo to lToNo
//	   		sIpgNo = Mid('00000' + String(lIpgNo), Len(String(lIpgNo)), 6)
//			
//   	   	Update ipgumpyo 
//				Set    rcv_date = :sRcvDate, rcvemp = :sRcvEmp
//   	   	Where  ipgum_no = :sIpgNo;
//	   		if SQLCA.Sqlcode = -1 then
//               f_message_Chk(32,'[입금표수령 UPDATE]')	
//            	rollback;
//   				SetPointer(Arrow!)
//            	ib_any_typing = True
//            	Return
//            end if				
//	   	next			
//		end if
//	end if
//next
//
//Commit;
//
//sle_msg.Text = '개인 영업사원별 입금표 배포 등록'
//
//if tab_1.tab2.dw_select2.Update() = -1 then  
//   f_message_Chk(32,'[영업사원별 입금표 배포]')
//	Rollback;
//	SetPointer(Arrow!)
//  	ib_any_typing = True
//	return
//end if
//
//commit;
//
//sle_msg.Text = '입금표 사원변경 및 폐기등록'
//
//if tab_1.tab3.dw_select3.Update() = -1 then  
//   f_message_Chk(32,'[입금표변경 및 폐기등록]')
//	Rollback;
//	SetPointer(Arrow!)
//  	ib_any_typing = True
//	return
//end if
//
//commit;
//
//sle_msg.Text = ''
//
//SetPointer(Arrow!)
//
//f_message_chk(202, '[입금표 수령 및 사원별 배포]')
//
//ib_any_typing = False
end event

type cb_ins from w_inherite`cb_ins within w_sal_04040
int X=521
int Y=2540
int TabOrder=30
boolean Visible=false
end type

type cb_del from w_inherite`cb_del within w_sal_04040
int X=1257
int Y=2536
int TabOrder=50
boolean Visible=false
end type

type cb_inq from w_inherite`cb_inq within w_sal_04040
int X=1618
int Y=2536
int TabOrder=70
boolean Visible=false
end type

type cb_print from w_inherite`cb_print within w_sal_04040
int X=1979
int Y=2536
int TabOrder=80
boolean Visible=false
end type

type cb_can from w_inherite`cb_can within w_sal_04040
int X=2341
int Y=2536
int TabOrder=90
boolean Visible=false
end type

type cb_search from w_inherite`cb_search within w_sal_04040
int X=2702
int Y=2536
int TabOrder=100
boolean Visible=false
end type

type tab_1 from tab within w_sal_04040
int X=114
int Y=44
int Width=3447
int Height=1848
int TabOrder=20
boolean BringToTop=true
boolean RaggedRight=true
boolean BoldSelectedText=true
int SelectedTab=1
long BackColor=79741120
int TextSize=-9
int Weight=400
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
tab1 tab1
tab2 tab2
tab3 tab3
end type

on tab_1.create
this.tab1=create tab1
this.tab2=create tab2
this.tab3=create tab3
this.Control[]={this.tab1,&
this.tab2,&
this.tab3}
end on

on tab_1.destroy
destroy(this.tab1)
destroy(this.tab2)
destroy(this.tab3)
end on

event selectionchanged;String  sNull

SetNull(sNull)

ib_any_typing = False

Choose Case tab_1.SelectedTab
	Case 1
  		idw_select = tab_1.tab1.dw_select1
		tab_1.tab1.dw_sarea1.visible = False
		tab_1.tab1.rb_new.SetFocus()
		tab_1.tab1.rb_new.TriggerEvent(Clicked!)
	Case 2
		idw_select = tab_1.tab2.dw_select2
		tab_1.tab2.dw_sarea2.SetFocus()
		idw_select.reset()
	Case 3
		idw_select = tab_1.tab3.dw_select3
		tab_1.tab3.dw_Jogun.Reset()
		tab_1.tab3.dw_Jogun.InsertRow(0)
		idw_select.reset()
		tab_1.tab3.dw_Jogun.SetFocus()
End Choose
end event

event selectionchanging;sle_msg.text =""
IF wf_mod_chk("종료") = -1 THEN
//	tab_1.SelectedTab = ii_tab
	RETURN 1
end if
end event

type tab1 from userobject within tab_1
int X=18
int Y=96
int Width=3410
int Height=1736
long BackColor=79741120
string Text="입금표 수령 등록"
long TabBackColor=79741120
long TabTextColor=33554432
long PictureMaskColor=536870912
gb_4 gb_4
gb_3 gb_3
dw_select1 dw_select1
rb_new rb_new
rb_old rb_old
dw_sarea1 dw_sarea1
gb_15 gb_15
cb_mod1 cb_mod1
end type

on tab1.create
this.gb_4=create gb_4
this.gb_3=create gb_3
this.dw_select1=create dw_select1
this.rb_new=create rb_new
this.rb_old=create rb_old
this.dw_sarea1=create dw_sarea1
this.gb_15=create gb_15
this.cb_mod1=create cb_mod1
this.Control[]={this.gb_4,&
this.gb_3,&
this.dw_select1,&
this.rb_new,&
this.rb_old,&
this.dw_sarea1,&
this.gb_15,&
this.cb_mod1}
end on

on tab1.destroy
destroy(this.gb_4)
destroy(this.gb_3)
destroy(this.dw_select1)
destroy(this.rb_new)
destroy(this.rb_old)
destroy(this.dw_sarea1)
destroy(this.gb_15)
destroy(this.cb_mod1)
end on

type gb_4 from groupbox within tab1
int X=59
int Y=208
int Width=3273
int Height=1368
int TabOrder=30
BorderStyle BorderStyle=StyleRaised!
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type gb_3 from groupbox within tab1
int X=59
int Y=28
int Width=3273
int Height=176
int TabOrder=10
BorderStyle BorderStyle=StyleRaised!
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type dw_select1 from u_key_enter within tab1
event ue_key pbm_dwnkey
int X=69
int Y=240
int Width=3250
int Height=1324
int TabOrder=20
boolean BringToTop=true
string DataObject="d_sal_04040"
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
end type

event itemerror;return 1
end event

event dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

For iPos = Len(sErrorSyntax) to 1 STEP -1
	 sMsg = Mid(sErrorSyntax, ipos, 1)
	 If sMsg   = sReturn or sMsg = sNewline Then
		 iCount++
	 End if
Next

sErrorSynTax  	= Left(sErrorSyntax, Len(sErrorsyntax) - iCount)


str_db_error db_error_msg
db_error_msg.rowno 	 				= row
db_error_msg.errorcode 				= sErrorCode
db_error_msg.errorsyntax_system	= sErrorSyntax
db_error_msg.errorsyntax_user		= sErrorSyntax
db_error_msg.errorsqlsyntax			= sqlsyntax
OpenWithParm(w_error, db_error_msg)


/*sMsg = "Row No       -> " + String(row) 			 + '~n' + &
		 "Error Code   -> " + sErrorcode			    + '~n' + &
		 "Error Syntax -> " + sErrorSyntax			 + '~n' + &
		 "SqlSyntax    -> " + Sqlsyntax
	MESSAGEBOX("자료처리중 오류발생", sMsg) */

RETURN 1
end event

event itemchanged;String sCol_Name, sNull, sRcvEmp, sEmpName
Long   CurRow

sCol_Name = this.GetColumnName()
SetNull(sNull)

CurRow = this.GetRow()

Choose Case sCol_Name
	// 수령일자 유효성 Check
   Case "rcv_date"
		if f_DateChk(Trim(this.getText())) = -1 then
			this.SetItem(1, "rcv_date", sNull)
			f_Message_Chk(35, '[수령일자]')
			return 1
		end if
		
	// 수령자코드 입력시	
	Case "rcvemp"
		sRcvEmp = this.GetText()
      
		//************************************************
		Select empname Into :sEmpName From p1_master
		Where empno = :sRcvEmp;
		//************************************************
		if sEmpName = '' or isNull(sEmpName) then
 			f_Message_Chk(33, '[수령담당자]')
			this.SetItem(CurRow, "rcvemp", sNull)
			this.SetItem(CurRow, "empname", sNull)
			return 1
		else
			this.SetItem(CurRow, "empname", sEmpName)
		end if
end Choose
end event

event rbuttondown;String sCol_Name
Long   CurRow

CurRow = this.GetRow()

sCol_Name = This.GetColumnName()
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case sCol_Name
   // 수령자 에디트에 Right 버턴클릭시 Popup 화면
	Case "rcvemp"
		gs_code = this.GetText()
		Open(w_sawon_popup)
		
		if gs_code = "" or isnull(gs_code) then return
		
		this.SetItem(CurRow, 'rcvemp', gs_code)
		this.SetItem(CurRow, 'empname', gs_codename)
		ib_any_typing = True
		ii_tab = tab_1.SelectedTab
end Choose
end event

event editchanged;ii_tab = tab_1.SelectedTab
ib_any_typing =True
end event

type rb_new from radiobutton within tab1
int X=553
int Y=88
int Width=288
int Height=76
boolean BringToTop=true
string Text="등 록"
BorderStyle BorderStyle=StyleLowered!
boolean Checked=true
long TextColor=16711680
long BackColor=67108864
int TextSize=-9
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

event clicked;Integer i

tab_1.tab1.dw_sarea1.Visible = False
idw_Select.SetFilter("isNull(rcv_date) or isNull(rcvemp)")
idw_Select.Filter()

if idw_Select.Retrieve('%') = 0 then
//	f_message_chk(300, '[등 록]')
	return
end if

for i = 1 to idw_Select.RowCount()
	idw_Select.SetItem(i, 'rcv_date', f_today())
next

idw_Select.SetFocus()
end event

type rb_old from radiobutton within tab1
int X=1070
int Y=88
int Width=288
int Height=76
boolean BringToTop=true
string Text="수 정"
BorderStyle BorderStyle=StyleLowered!
long TextColor=8388736
long BackColor=67108864
int TextSize=-9
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

event clicked;tab_1.tab1.dw_sarea1.visible = True

idw_Select.SetFilter("Not(isNull(rcv_date) or isNull(rcvemp))")
idw_Select.Filter()

if idw_Select.Retrieve('%') = 0 then
	f_message_chk(300, '[수 정]')
	return
end if

tab_1.tab1.dw_sarea1.SetFocus()
end event

type dw_sarea1 from datawindow within tab1
int X=1769
int Y=84
int Width=1120
int Height=76
int TabOrder=30
boolean BringToTop=true
string DataObject="d_sal_04040_01"
boolean Border=false
boolean LiveScroll=true
end type

event itemchanged;String sSarea

sSarea = this.GetText()

if sSarea = '00' then
	sSarea = '%'
end if

if idw_Select.Retrieve(sSarea) = 0 then
	f_message_chk(300, '[수 정]')
	return
end if
end event

type gb_15 from groupbox within tab1
int X=2862
int Y=1560
int Width=475
int Height=168
int TabOrder=80
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type cb_mod1 from commandbutton within tab1
int X=2898
int Y=1604
int Width=407
int Height=108
int TabOrder=40
boolean BringToTop=true
string Text="저  장"
int TextSize=-10
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

event clicked;Integer i
String  sDstDate, sSarea, sRcvDate, sRcvEmp, sIpgNo
Long    lFromNo, lToNo, lIpgNo, lrow = 0

SetPointer(HourGlass!)
sle_msg.Text = '관할구역별 수령일자 및 수령자 등록 및 수정'

if idw_select.Accepttext() = -1 then return

if rb_new.Checked = True then // 입력 Mode일 경우
   for i = 1 to idw_select.RowCount()
	   sDstDate = idw_select.GetItemString(i, 'dst_date')
   	sSarea   = idw_select.GetItemString(i, 'sarea')
	   sRcvDate = idw_select.GetItemString(i, 'rcv_date')
   	sRcvEmp  = idw_select.GetItemString(i, 'rcvemp')	
	   lFromNo  = Long(idw_select.GetItemString(i, 'ipgnofrom'))
   	lToNo    = Long(idw_select.GetItemString(i, 'ipgnoto'))
	
	   // 수령일자 및 수령자 등록된 ROW만 Update 처리
   	if not(sRcvDate = '' or isNull(sRcvDate)) then
	   	if not(sRcvEmp = '' or isNull(sRcvEmp)) then
 
         	Update ipgumpyo_dst 
		   	Set    rcv_date = :sRcvDate, rcvemp = :sRcvEmp
      	   Where  dst_date = :sDstDate and sarea = :sSarea;
			
   			if SQLCA.SqlCode = -1 then
	   			f_message_chk(32, '[입금표수령 UPDATE(DST)]')
		   		Rollback;
			   	SetPointer(Arrow!)
           	   ib_any_typing = True
   				return
	   		end if
			
		   	// 입금표 테이블에 입금번호별로 수령정보 등록
   		   for lIpgNo = lFromNo to lToNo
	   		   sIpgNo = Mid('0000000' + String(lIpgNo), Len(String(lIpgNo)), 8)
			
      	   	Update ipgumpyo 
	   			Set    rcv_date = :sRcvDate, rcvemp = :sRcvEmp
   	      	Where  ipgum_no = :sIpgNo;
	   	   	if SQLCA.Sqlcode = -1 then
                  f_message_Chk(32,'[입금표수령 UPDATE]')	
            	   rollback;
      				SetPointer(Arrow!)
               	ib_any_typing = True
               	Return
               end if				
   	   	next			
	   	end if
   	end if
   next
elseif rb_old.Checked = True then // 수정 Mode일 경우
   // 수령일자 및 수령자가 Modify된 ROW를 찾아 일괄 Update
	Do While lrow <= idw_select.RowCount()
      lrow = idw_select.GetNextModified(lrow, Primary!)
     	if lrow > 0 then
   	   sDstDate = idw_select.GetItemString(lrow, 'dst_date')
      	sSarea   = idw_select.GetItemString(lrow, 'sarea')
	      sRcvDate = idw_select.GetItemString(lrow, 'rcv_date')
      	sRcvEmp  = idw_select.GetItemString(lrow, 'rcvemp')	
	      lFromNo  = Long(idw_select.GetItemString(lrow, 'ipgnofrom'))
   	   lToNo    = Long(idw_select.GetItemString(lrow, 'ipgnoto'))
			
         Update ipgumpyo_dst 
		   Set    rcv_date = :sRcvDate, rcvemp = :sRcvEmp
      	Where  dst_date = :sDstDate and sarea = :sSarea;
			
   		if SQLCA.SqlCode = -1 then
	   		f_message_chk(32, '[입금표수령 UPDATE(DST)]')
		   	Rollback;
			  	SetPointer(Arrow!)
            ib_any_typing = True
   			return
	   	end if
			
	   	// 입금표 테이블에 입금번호별로 수령정보 수정
  		   for lIpgNo = lFromNo to lToNo
   		   sIpgNo = Mid('0000000' + String(lIpgNo), Len(String(lIpgNo)), 8)
		
     	   	Update ipgumpyo 
   			Set    rcv_date = :sRcvDate, rcvemp = :sRcvEmp
  	      	Where  ipgum_no = :sIpgNo;
   	   	if SQLCA.Sqlcode = -1 then
               f_message_Chk(32,'[입금표수령 UPDATE]')	
           	   rollback;
     				SetPointer(Arrow!)
              	ib_any_typing = True
              	Return
            end if				
  	   	next						
      else
     		lrow = idw_select.RowCount() + 1
     	end if
   Loop				
end if

Commit;

sle_msg.Text = ''

SetPointer(Arrow!)

f_message_chk(202, '[입금표 수령 등록]')

ib_any_typing = False
end event

type tab2 from userobject within tab_1
int X=18
int Y=96
int Width=3410
int Height=1736
long BackColor=79741120
string Text="개인별 배포 등록"
long TabBackColor=79741120
long TabTextColor=33554432
long PictureMaskColor=536870912
gb_2 gb_2
gb_1 gb_1
gb_6 gb_6
gb_5 gb_5
dw_select2 dw_select2
dw_sarea2 dw_sarea2
st_2 st_2
dw_emp_id dw_emp_id
st_3 st_3
st_4 st_4
st_5 st_5
st_6 st_6
st_7 st_7
st_8 st_8
st_9 st_9
cb_mod2 cb_mod2
gb_14 gb_14
end type

on tab2.create
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_6=create gb_6
this.gb_5=create gb_5
this.dw_select2=create dw_select2
this.dw_sarea2=create dw_sarea2
this.st_2=create st_2
this.dw_emp_id=create dw_emp_id
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.st_6=create st_6
this.st_7=create st_7
this.st_8=create st_8
this.st_9=create st_9
this.cb_mod2=create cb_mod2
this.gb_14=create gb_14
this.Control[]={this.gb_2,&
this.gb_1,&
this.gb_6,&
this.gb_5,&
this.dw_select2,&
this.dw_sarea2,&
this.st_2,&
this.dw_emp_id,&
this.st_3,&
this.st_4,&
this.st_5,&
this.st_6,&
this.st_7,&
this.st_8,&
this.st_9,&
this.cb_mod2,&
this.gb_14}
end on

on tab2.destroy
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.gb_6)
destroy(this.gb_5)
destroy(this.dw_select2)
destroy(this.dw_sarea2)
destroy(this.st_2)
destroy(this.dw_emp_id)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.st_7)
destroy(this.st_8)
destroy(this.st_9)
destroy(this.cb_mod2)
destroy(this.gb_14)
end on

type gb_2 from groupbox within tab2
int X=2309
int Y=156
int Width=1029
int Height=676
int TabOrder=40
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type gb_1 from groupbox within tab2
int X=2309
int Y=812
int Width=1029
int Height=740
int TabOrder=30
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type gb_6 from groupbox within tab2
int X=50
int Y=180
int Width=2190
int Height=1540
int TabOrder=30
BorderStyle BorderStyle=StyleRaised!
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type gb_5 from groupbox within tab2
int X=50
int Y=20
int Width=2190
int Height=160
int TabOrder=30
BorderStyle BorderStyle=StyleRaised!
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type dw_select2 from u_key_enter within tab2
event mousemove pbm_dwnmousemove
int X=59
int Y=212
int Width=2167
int Height=1496
int TabOrder=11
boolean BringToTop=true
string DataObject="d_sal_04040_02"
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
end type

event mousemove;If row <=0 Then Return

if Keydown(KeyLeftButton! ) then
   this.SelectRow(row,true)
end if
end event

event rowfocuschanged;/*******************************************************************/
/*** DataWindow Multi Select(Ctrl, Shift)                        ***/
/*******************************************************************/
Integer crow,fr_row,to_row,ix
Long    row 

row = currentrow

If row <=0 Then Return

If keydown(KeyControl!) Then
	If Keydown(KeyUpArrow!) Or Keydown(KeyDownArrow!) Then This.SelectRow(0,false)
		
	If IsSelected(row) Then
	  This.SelectRow(row,false)
   Else
	  This.SelectRow(row,True)
   end If
	
ElseIf keydown(keyShift!) Then
	This.SelectRow(0,false)
   If il_sRow < row Then
		fr_row  = il_sRow
		to_row  = row
	Else
		fr_row = row
		to_row = il_sRow
	End If

	For ix = fr_row To to_row
		This.SelectRow(ix,true)
	Next
Else
	This.SelectRow(0,false)
	This.SelectRow(row,true)
//	This.ScrollToRow(row)
	il_sRow = row
End If
/* -------------------------------------------------------- */
//string snull
//
//setnull(snull)
//
//dw_emp_id.SetItem(1,'emp_id',snull)

end event

event itemerror;return 1
end event

event dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

For iPos = Len(sErrorSyntax) to 1 STEP -1
	 sMsg = Mid(sErrorSyntax, ipos, 1)
	 If sMsg   = sReturn or sMsg = sNewline Then
		 iCount++
	 End if
Next

sErrorSynTax  	= Left(sErrorSyntax, Len(sErrorsyntax) - iCount)


str_db_error db_error_msg
db_error_msg.rowno 	 				= row
db_error_msg.errorcode 				= sErrorCode
db_error_msg.errorsyntax_system	= sErrorSyntax
db_error_msg.errorsyntax_user		= sErrorSyntax
db_error_msg.errorsqlsyntax			= sqlsyntax
OpenWithParm(w_error, db_error_msg)


/*sMsg = "Row No       -> " + String(row) 			 + '~n' + &
		 "Error Code   -> " + sErrorcode			    + '~n' + &
		 "Error Syntax -> " + sErrorSyntax			 + '~n' + &
		 "SqlSyntax    -> " + Sqlsyntax
	MESSAGEBOX("자료처리중 오류발생", sMsg) */

RETURN 1
end event

event editchanged;ib_any_typing =True
end event

type dw_sarea2 from datawindow within tab2
int X=101
int Y=72
int Width=1865
int Height=80
int TabOrder=40
boolean BringToTop=true
string DataObject="d_sal_04040_01"
boolean Border=false
boolean LiveScroll=true
end type

event itemchanged;String sSarea, sUseGu

Choose Case GetColumnName()
	Case 'sarea'
		sSarea = Trim(GetText())
		sUseGu = GetItemString(1,'use_gu')
		
		If sSarea = '00' then	sSarea = ''
		
		dw_emp_id.Retrieve(ssArea+'%')
		If idw_Select.Retrieve(sSarea+'%', sUseGu) = 0 then
			f_message_chk(300, '[미사용입금표]')
			Return
		End If
	Case 'use_gu'
		sSarea = GetItemString(1,'sarea')
		sUseGu = Trim(GetText())
		
		If sSarea = '00' then	sSarea = ''
		
		If idw_Select.Retrieve(sSarea+'%', sUseGu) = 0 then
			f_message_chk(300, '[미사용입금표]')
			Return
		End If
End Choose
end event

event itemerror;Return 1
end event

type st_2 from statictext within tab2
int X=2336
int Y=96
int Width=997
int Height=68
boolean Enabled=false
boolean BringToTop=true
string Text="[ 영업사원 일괄 등록 선택 ]"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=128
long BackColor=67108864
int TextSize=-10
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type dw_emp_id from datawindow within tab2
int X=2368
int Y=204
int Width=878
int Height=592
int TabOrder=21
string Tag="d_sal_04040_03"
boolean BringToTop=true
string DataObject="d_sal_04040_03"
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
boolean LiveScroll=true
end type

event clicked;String sEmpId, sNull
Long   i

SetNull(sNull)
If idw_Select.AcceptText() <> 1 Then Return

If row <= 0 Then Return

sEmpId = Trim(GetItemString(row,'rfgub'))

for i = 1 to idw_Select.RowCount()
   if idw_Select.isSelected(i) then
		idw_Select.SetItem(i, 'dst_emp_date', f_today())
		idw_Select.SetItem(i, 'emp_id', sEmpId)		
	end if
next

idw_Select.SelectRow(0,false)

This.SelectRow(0,  False)
This.SelectRow(row,True)

//this.SetItem(1, 'emp_id', sNull)
end event

type st_3 from statictext within tab2
int X=2331
int Y=864
int Width=997
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="왼쪽의 관할구역별 입금표 내역에서"
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

type st_4 from statictext within tab2
int X=2331
int Y=996
int Width=997
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="배포할 입금표번호를 마우스나"
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

type st_5 from statictext within tab2
int X=2331
int Y=1088
int Width=997
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="화살표 KEY(Ctrl,Shift 포함)로"
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

type st_6 from statictext within tab2
int X=2331
int Y=1272
int Width=997
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="콤보박스에서 해당 영업사원을"
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

type st_7 from statictext within tab2
int X=2331
int Y=1364
int Width=997
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="선택하여 선택된 범위의 입금표에"
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

type st_8 from statictext within tab2
int X=2331
int Y=1180
int Width=997
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="범위를 선택하여 상단에 있는"
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

type st_9 from statictext within tab2
int X=2331
int Y=1456
int Width=997
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="일괄 등록한다."
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

type cb_mod2 from commandbutton within tab2
int X=2930
int Y=1604
int Width=402
int Height=108
int TabOrder=40
boolean BringToTop=true
string Text="저  장"
int TextSize=-10
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

event clicked;SetPointer(HourGlass!)

sle_msg.Text = '개인 영업사원별 입금표 배포 등록'

if tab_1.tab2.dw_select2.Update() = -1 then  
   f_message_Chk(32,'[영업사원별 입금표 배포]')
	Rollback;
	SetPointer(Arrow!)
  	ib_any_typing = True
	return
end if

commit;

sle_msg.Text = ''

SetPointer(Arrow!)

f_message_chk(202, '[사원별 입금표 배포]')

ib_any_typing = False
end event

type gb_14 from groupbox within tab2
int X=2894
int Y=1560
int Width=475
int Height=168
int TabOrder=70
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type tab3 from userobject within tab_1
int X=18
int Y=96
int Width=3410
int Height=1736
long BackColor=79741120
string Text="입금표조회,변경,폐기"
long TabBackColor=79741120
long TabTextColor=33554432
long PictureMaskColor=536870912
gb_12 gb_12
gb_11 gb_11
gb_9 gb_9
dw_select3 dw_select3
dw_jogun dw_jogun
cb_inq3 cb_inq3
gb_13 gb_13
cb_mod3 cb_mod3
end type

on tab3.create
this.gb_12=create gb_12
this.gb_11=create gb_11
this.gb_9=create gb_9
this.dw_select3=create dw_select3
this.dw_jogun=create dw_jogun
this.cb_inq3=create cb_inq3
this.gb_13=create gb_13
this.cb_mod3=create cb_mod3
this.Control[]={this.gb_12,&
this.gb_11,&
this.gb_9,&
this.dw_select3,&
this.dw_jogun,&
this.cb_inq3,&
this.gb_13,&
this.cb_mod3}
end on

on tab3.destroy
destroy(this.gb_12)
destroy(this.gb_11)
destroy(this.gb_9)
destroy(this.dw_select3)
destroy(this.dw_jogun)
destroy(this.cb_inq3)
destroy(this.gb_13)
destroy(this.cb_mod3)
end on

type gb_12 from groupbox within tab3
int X=2830
int Y=24
int Width=480
int Height=176
int TabOrder=30
BorderStyle BorderStyle=StyleRaised!
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=400
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type gb_11 from groupbox within tab3
int X=91
int Y=24
int Width=2738
int Height=176
int TabOrder=20
BorderStyle BorderStyle=StyleRaised!
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=400
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type gb_9 from groupbox within tab3
int X=91
int Y=200
int Width=3223
int Height=1372
int TabOrder=30
BorderStyle BorderStyle=StyleRaised!
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=400
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type dw_select3 from u_key_enter within tab3
event ue_key pbm_dwnkey
int X=101
int Y=232
int Width=3200
int Height=1328
int TabOrder=30
boolean BringToTop=true
string DataObject="d_sal_04040_05"
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
end type

event dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

For iPos = Len(sErrorSyntax) to 1 STEP -1
	 sMsg = Mid(sErrorSyntax, ipos, 1)
	 If sMsg   = sReturn or sMsg = sNewline Then
		 iCount++
	 End if
Next

sErrorSynTax  	= Left(sErrorSyntax, Len(sErrorsyntax) - iCount)


str_db_error db_error_msg
db_error_msg.rowno 	 				= row
db_error_msg.errorcode 				= sErrorCode
db_error_msg.errorsyntax_system	= sErrorSyntax
db_error_msg.errorsyntax_user		= sErrorSyntax
db_error_msg.errorsqlsyntax			= sqlsyntax
OpenWithParm(w_error, db_error_msg)


/*sMsg = "Row No       -> " + String(row) 			 + '~n' + &
		 "Error Code   -> " + sErrorcode			    + '~n' + &
		 "Error Syntax -> " + sErrorSyntax			 + '~n' + &
		 "SqlSyntax    -> " + Sqlsyntax
	MESSAGEBOX("자료처리중 오류발생", sMsg) */

RETURN 1
end event

event itemchanged;String sNull, sDate, sIpgumNo, sUsegu, sOldUseGu
Long   nRow, nCnt

SetNull(sNull)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
   Case "use_gu"
		sUseGu = Trim(GetText())
		sOldUseGu = Trim(GetItemString(nRow,'use_gu',Primary!, True))
		
		sIpgumNo = Trim(GetItemString(nRow,'ipgum_no'))
		/* 사용 -> 미사용 */
		If sOldUseGu = '2' and sUseGu = '1' Then
			Select count(*) into :ncnt 
			  from sugum
			 where sabu = '1' and
			       ipgum_no = :sIpgumNo;
			
			If nCnt > 0 Then
				MessageBox('확 인','사용중인 입금표번호입니다.!!')
				Return 2
			End If
			
			SetItem(nRow,'waste_date',sNull)
		End If
		
		SetColumn('waste_date')
		SetFocus()
	// 폐기일자 유효성 Check
   Case "waste_date"
		sDate = Trim(GetText())
		If IsNull(sDate) or sDate = '' then Return
		
		If f_DateChk(sDate) = -1 then
			SetItem(1, "waste_date", sNull)
			f_Message_Chk(35, '[폐기일자]')
			return 1
		end if		
end Choose
end event

event itemerror;return 1
end event

event rowfocuschanged;this.SetRowFocusIndicator(Hand!, 8, 0)
end event

event itemfocuschanged;if (this.GetColumnName() = "bigo") then
	f_toggle_kor(handle(parent))		// 한글 모드
else
	f_toggle_eng(handle(parent))		// 영문 모드
end if
end event

event editchanged;ib_any_typing =True
end event

type dw_jogun from datawindow within tab3
event ue_pressenter pbm_dwnprocessenter
int X=279
int Y=80
int Width=2405
int Height=88
int TabOrder=40
boolean BringToTop=true
string DataObject="d_sal_04040_04"
boolean Border=false
boolean LiveScroll=true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String sCol_Name, sNull, sNoFrom, sNoTo
Long   CurRow

sCol_Name = this.GetColumnName()
SetNull(sNull)

CurRow = this.GetRow()

Choose Case sCol_Name
	// 입금표번호 FROM 입력시	
	Case "ipno_from"
		sNoFrom = this.GetText()
		if Not(isNumber(sNoFrom)) then
			f_Message_Chk(201, '[입금표번호]')
			this.SetItem(CurRow, "ipno_from", sNull)
			return 1
		end if
		sNoFrom = Mid('0000000' + sNoFrom, Len(Trim(sNoFrom)), 8)
		this.SetItem(CurRow, "ipno_from", sNoFrom)
		
		return 2
      
	// 입금표번호 TO 입력시	
	Case "ipno_to"
		sNoTo = this.GetText()
		if Not(isNumber(sNoTo)) then
			f_Message_Chk(201, '[입금표번호]')
			this.SetItem(CurRow, "ipno_to", sNull)
			return 1
		end if

		sNoTo = Mid('0000000' + sNoTo, Len(Trim(sNoTo)), 8)
		this.SetItem(CurRow, "ipno_to", sNoTo)		
		
		sNoFrom = this.GetItemString(CurRow, "ipno_from")
		if Long(sNoFrom) > Long(sNoTo) then
			MessageBox('확인', '시작번호가 끝번호보다 큽니다. 다시 입력하세요!!!')
			this.SetColumn('ipno_from')
			this.SetFocus()
			return 1
		end if		
		return 2
end Choose
end event

event itemerror;RETURN 1
end event

type cb_inq3 from commandbutton within tab3
int X=2862
int Y=72
int Width=407
int Height=108
int TabOrder=50
boolean BringToTop=true
string Text="조 회(&R)"
int TextSize=-10
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

event clicked;String sIpnoFrom, sIpnoTo, sSarea

tab_1.tab3.dw_Jogun.AcceptText()

sIpnoFrom = tab_1.tab3.dw_Jogun.GetItemString(1, 'ipno_from')
if sIpnoFrom = '' or isNull(sIpnoFrom) then sIpnoFrom = '00000000'

sIpnoTo = tab_1.tab3.dw_Jogun.GetItemString(1, 'ipno_to')
if sIpnoTo = '' or isNull(sIpnoTo) then sIpnoTo = '99999999'

sSarea = tab_1.tab3.dw_Jogun.GetItemString(1, 'sarea')
if sSarea = '' or isNull(sSarea) or sSarea = '00' then sSarea = '%'

if idw_Select.Retrieve(sIpnoFrom, sIpnoTo, sSarea) = -1 then return

idw_Select.SetFocus()
end event

type gb_13 from groupbox within tab3
int X=2843
int Y=1556
int Width=471
int Height=168
int TabOrder=60
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type cb_mod3 from commandbutton within tab3
int X=2880
int Y=1600
int Width=402
int Height=108
int TabOrder=50
boolean BringToTop=true
string Text="저  장"
int TextSize=-10
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

event clicked;SetPointer(HourGlass!)

sle_msg.Text = '입금표 사원변경 및 폐기등록'

if tab_1.tab3.dw_select3.Update() = -1 then  
   f_message_Chk(32,'[입금표변경 및 폐기등록]')
	Rollback;
	SetPointer(Arrow!)
  	ib_any_typing = True
	return
end if

commit;

sle_msg.Text = ''

SetPointer(Arrow!)

f_message_chk(202, '[입금표 수령 및 사원별 배포]')

ib_any_typing = False
end event

type gb_7 from groupbox within w_sal_04040
int X=3077
int Y=1892
int Width=480
int Height=176
int TabOrder=60
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

