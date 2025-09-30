$PBExportHeader$w_sal_05000.srw
$PBExportComments$수주일마감
forward
global type w_sal_05000 from w_inherite
end type
type st_2 from statictext within w_sal_05000
end type
type st_3 from statictext within w_sal_05000
end type
type st_4 from statictext within w_sal_05000
end type
type gb_3 from groupbox within w_sal_05000
end type
type gb_2 from groupbox within w_sal_05000
end type
type gb_1 from groupbox within w_sal_05000
end type
end forward

global type w_sal_05000 from w_inherite
boolean TitleBar=true
string Title="수주 일마감"
WindowState WindowState=normal!
st_2 st_2
st_3 st_3
st_4 st_4
gb_3 gb_3
gb_2 gb_2
gb_1 gb_1
end type
global w_sal_05000 w_sal_05000

on w_sal_05000.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.gb_3=create gb_3
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.gb_3
this.Control[iCurrent+5]=this.gb_2
this.Control[iCurrent+6]=this.gb_1
end on

on w_sal_05000.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event open;call super::open;string sdate
int    nRow

sdate = f_today()

nRow = dw_insert.InsertRow(0)
dw_insert.SetItem(nrow,'sdate',sdate)
end event

type dw_insert from w_inherite`dw_insert within w_sal_05000
int X=1257
int Y=504
int Width=869
int Height=112
int TabOrder=10
string DataObject="d_sal_05000_01"
end type

event dw_insert::itemchanged;String sDate

Choose Case GetColumnName()
	Case 'sdate'
		sdate = Left(data,4) + Mid(data,5,2) + Right(data,2)
		If f_datechk(sdate) <> 1 Then
			f_message_chk(35,'')
	      Return 1
      END IF
End Choose
end event

event dw_insert::editchanged;ib_any_typing = False
end event

event dw_insert::itemerror;call super::itemerror;Return 1
end event

type cb_exit from w_inherite`cb_exit within w_sal_05000
int X=1989
int Y=1200
int Width=443
int TabOrder=40
end type

type cb_mod from w_inherite`cb_mod within w_sal_05000
int X=878
int Y=2416
int TabOrder=0
boolean Visible=false
boolean Enabled=false
end type

type cb_ins from w_inherite`cb_ins within w_sal_05000
int X=517
int Y=2416
int TabOrder=0
boolean Visible=false
end type

type cb_del from w_inherite`cb_del within w_sal_05000
int X=1239
int Y=2416
int TabOrder=0
boolean Visible=false
boolean Enabled=false
end type

type cb_inq from w_inherite`cb_inq within w_sal_05000
int X=1600
int Y=2416
int TabOrder=0
boolean Visible=false
boolean Enabled=false
end type

type cb_print from w_inherite`cb_print within w_sal_05000
int X=1961
int Y=2416
int TabOrder=0
boolean Visible=false
boolean Enabled=false
end type

type cb_can from w_inherite`cb_can within w_sal_05000
int X=1509
int Y=1200
int Width=443
int TabOrder=30
string Text="마감취소(&C)"
end type

event cb_can::clicked;call super::clicked;string sDate
int    nRow,nCnt

dw_insert.AcceptText()
nRow  = dw_insert.GetRow()
If nRow <=0 Then Return
	  
sDate = Trim(dw_insert.GetItemString(nRow,'sdate'))
If IsNull(sdate) Or sdate = '' Then
   f_message_chk(1400,'[마감일자]')
	Return 1
End If


/* 마감처리된 일자 확인 */
  SELECT count("JUNPYO_CLOSING"."JPDAT"  )
    INTO :nCnt
    FROM "JUNPYO_CLOSING"  
   WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
         ( "JUNPYO_CLOSING"."JPGU" = 'S0' ) AND  
         ( "JUNPYO_CLOSING"."JPDAT" = :sDate )   ;

If nCnt = 0 Then
	f_message_chk(66,'[마감처리 확인]')
	Return 
End If

IF MessageBox("취  소", "일마감이 취소 처리됩니다." +"~n~n" +&
                     	"취소 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN


DELETE FROM "JUNPYO_CLOSING"  
   WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
         ( "JUNPYO_CLOSING"."JPGU" = 'S0' ) AND  
         ( "JUNPYO_CLOSING"."JPDAT" = :sDate ) AND  
         ( "JUNPYO_CLOSING"."DEPOT" = '000000' )   ;

Choose Case sqlca.sqlcode
	Case 0
		commit;
		MessageBox('수주 일마감 취소','마감취소 되었습니다.')
	Case Else
		rollback;
		f_message_chk(32,sqlca.sqlerrtext)
End Choose

end event

type cb_search from w_inherite`cb_search within w_sal_05000
int X=1029
int Y=1200
int Width=443
int TabOrder=20
string Text="마감처리(&P)"
end type

event cb_search::clicked;call super::clicked;string sDate
int    nRow,nCnt

dw_insert.AcceptText()
nRow  = dw_insert.GetRow()
If nRow <=0 Then Return
	  
sDate = Trim(dw_insert.GetItemString(nRow,'sdate'))
If IsNull(sdate) Or sdate = '' Then
   f_message_chk(1400,'[마감일자]')
	Return 1
End If

/* 마감처리된 일자 확인 */
  SELECT count("JUNPYO_CLOSING"."JPDAT"  )
    INTO :nCnt
    FROM "JUNPYO_CLOSING"  
   WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
         ( "JUNPYO_CLOSING"."JPGU" = 'S0' ) AND  
         ( "JUNPYO_CLOSING"."JPDAT" = :sDate )   ;

If nCnt > 0 Then
	f_message_chk(60,'')
	Return 
End If

INSERT INTO "JUNPYO_CLOSING"  
         ( "SABU",           "JPGU",         "JPDAT",           "DEPOT" )  
  VALUES ( :gs_sabu,           'S0',         :sDate,           '000000' )  ;

Choose Case sqlca.sqlcode
	Case 0
		commit;
		MessageBox('수주 일마감','마감처리 되었습니다.')
	Case Else
		rollback;
		f_message_chk(32,sqlca.sqlerrtext)
End Choose

end event

type st_2 from statictext within w_sal_05000
int X=951
int Y=856
int Width=645
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="* 마감처리한 일자로는"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type st_3 from statictext within w_sal_05000
int X=1595
int Y=856
int Width=256
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="수주입력"
boolean FocusRectangle=false
long TextColor=255
long BackColor=67108864
int TextSize=-9
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type st_4 from statictext within w_sal_05000
int X=1833
int Y=856
int Width=590
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="을 할 수 없습니다."
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=700
string FaceName="굴림체"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type gb_3 from groupbox within w_sal_05000
int X=864
int Y=1092
int Width=1728
int Height=324
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

type gb_2 from groupbox within w_sal_05000
int X=864
int Y=708
int Width=1728
int Height=360
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

type gb_1 from groupbox within w_sal_05000
int X=859
int Y=392
int Width=1733
int Height=296
string Text="수주 일마감"
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

